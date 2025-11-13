# frozen_string_literal: true

require 'openssl'

params = OpenSSL::SSL::SSLContext::DEFAULT_PARAMS

params[:verify_mode] = OpenSSL::SSL::VERIFY_PEER

if params[:verify_flags]
  params[:verify_flags] &=
    ~(OpenSSL::X509::V_FLAG_CRL_CHECK_ALL | OpenSSL::X509::V_FLAG_CRL_CHECK)
end
