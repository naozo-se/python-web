ARG PYTHON_IMAGE_VERSION
FROM python:$PYTHON_IMAGE_VERSION

# パッケージ更新
RUN apt-get update

# 設定情報(UID,GIDについてはidコマンドでdockerの実行ユーザーと合わせた方がよい)
ARG USERNAME
ARG GROUPNAME
ARG UID
ARG GID
ARG WORKDIR

RUN echo $UID

# ユーザー追加
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID $USERNAME

# フォルダ作成＆管理者設定
RUN mkdir -p $WORKDIR
RUN chown -R $UID:$GID $WORKDIR

# ユーザーのbinaryディレクトリをパスに追加
ENV PATH /home/$USERNAME/.local/bin:$PATH

# ユーザー切り替え
USER $USERNAME

# 作業ディレクトリ設定
WORKDIR $WORKDIR

# パッケージ更新
RUN python -m pip install --upgrade --user pip
RUN python -m pip install --upgrade --user setuptools

# パッケージインストール
COPY requirements.txt $WORKDIR
RUN python -m pip install --user -r requirements.txt
