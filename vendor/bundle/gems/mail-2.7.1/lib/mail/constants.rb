# encoding: us-ascii
# frozen_string_literal: true

module Mail
  module Constants
    white_space = %(\x9\x20)
    text        = %(\x1-\x8\xB\xC\xE-\x7f)
    field_name  = %(\x21-\x39\x3b-\x7e)
    qp_safe     = %(\x20-\x3c\x3e-\x7e)

    aspecial     = %|()<>[]:;@\\,."| # RFC5322
    tspecial     = %|()<>@,;:\\"/[]?=| # RFC2045
    sp           = %( )
    control      = %(\x00-\x1f\x7f-\xff)

    control = control.dup.force_encoding(Encoding::BINARY) if control.respond_to?(:force_encoding)

    CRLF          = /\r?\n/.freeze
    WSP           = /[#{white_space}]/.freeze
    FWS           = /#{CRLF}#{WSP}*/.freeze
    TEXT          = /[#{text}]/.freeze # + obs-text
    FIELD_NAME    = /[#{field_name}]+/.freeze
    FIELD_PREFIX  = /\A(#{FIELD_NAME})/.freeze
    FIELD_BODY    = /.+/m.freeze
    FIELD_LINE    = /^[#{field_name}]+:\s*.+$/.freeze
    FIELD_SPLIT   = /^(#{FIELD_NAME})\s*:\s*(#{FIELD_BODY})?$/.freeze
    HEADER_LINE   = /^([#{field_name}]+:\s*.+)$/.freeze
    HEADER_SPLIT  = /#{CRLF}(?!#{WSP})/.freeze

    QP_UNSAFE     = /[^#{qp_safe}]/.freeze
    QP_SAFE       = /[#{qp_safe}]/.freeze
    CONTROL_CHAR  = /[#{control}]/n.freeze
    ATOM_UNSAFE   = /[#{Regexp.quote aspecial}#{control}#{sp}]/n.freeze
    PHRASE_UNSAFE = /[#{Regexp.quote aspecial}#{control}]/n.freeze
    TOKEN_UNSAFE  = /[#{Regexp.quote tspecial}#{control}#{sp}]/n.freeze
    ENCODED_VALUE = /\=\?([^?]+)\?([QB])\?[^?]*?\?\=/mi.freeze
    FULL_ENCODED_VALUE = /(\=\?[^?]+\?[QB]\?[^?]*?\?\=)/mi.freeze

    EMPTY          = ''
    SPACE          = ' '
    UNDERSCORE     = '_'
    HYPHEN         = '-'
    COLON          = ':'
    ASTERISK       = '*'
    CR             = "\r"
    LF             = "\n"
    CR_ENCODED     = '=0D'
    LF_ENCODED     = '=0A'
    CAPITAL_M      = 'M'
    EQUAL_LF       = "=\n"
    NULL_SENDER    = '<>'

    Q_VALUES       = %w[Q q].freeze
    B_VALUES       = %w[B b].freeze
  end
end
