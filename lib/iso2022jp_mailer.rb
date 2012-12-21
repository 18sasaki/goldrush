# -*- encoding: utf-8 -*-
# app/model/iso2022jp_mailer.rb
require 'nkf'
class Iso2022jpMailer < ActionMailer::Base
  @@default_charset = 'iso-2022-jp'  # ���ꂪ�Ȃ��� "Content-Type: charset=utf-8" �ɂȂ�
  @@encode_subject  = false          # �f�t�H���g�̃G���R�[�h�����͍s��Ȃ�(�����ł��)

  # 1) base64 �̕����� (http://wiki.fdiary.net/rails/?ActionMailer ���)
  def base64(text, charset="iso-2022-jp", convert=true)
    if convert
      if charset == "iso-2022-jp"
        text = NKF.nkf('-j -m0', text)
      end
    end
    text = [text].pack('m').delete("\r\n")
    "=?#{charset}?B?#{text}?="
  end

  # 2) �{���� iso-2022-jp �֕ϊ�
  # �ǂ��ł��΂����̂��������̂ŁA�Ƃ肠���� create! �ɔ킹�Ă��܂�
  def create! (*)
    super
    @mail.body = NKF::nkf('-j', @mail.body)
    return @mail   # ���\�b�h�`�F�C�������҂����ύX����������|���̂�
  end
end