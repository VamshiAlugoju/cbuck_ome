export const OME_CONFIG = {
  host: process.env.OME_HOST || '10.10.0.47',

  ports: {
    origin: parseInt(process.env.OME_ORIGIN_PORT || '9000', 10),

    ingest: {
      rtmp: parseInt(process.env.OME_RTMP_PROV_PORT || '1935', 10),
      srt: parseInt(process.env.OME_SRT_PROV_PORT || '9999', 10),
      mpegts: parseInt(process.env.OME_MPEGTS_PROV_PORT || '4000', 10),
      webrtcSignalling: parseInt(
        process.env.OME_WEBRTC_SIGNALLING_PORT || '3333',
        10,
      ),
      webrtcSignallingTls: parseInt(
        process.env.OME_WEBRTC_SIGNALLING_TLS_PORT || '3334',
        10,
      ),
      webrtcCandidateMin: parseInt(
        process.env.OME_WEBRTC_CANDIDATE_PORT?.split('-')[0] || '10000',
        10,
      ),
      webrtcCandidateMax: parseInt(
        process.env.OME_WEBRTC_CANDIDATE_PORT?.split('-')[1] || '10004',
        10,
      ),
    },

    delivery: {
      llhls: parseInt(process.env.OME_LLHLS_STREAM_PORT || '3333', 10),
      // llhlsTls: parseInt(process.env.OME_LLHLS_STREAM_TLS_PORTf || '3334', 10),
      webrtc: parseInt(process.env.OME_WEBRTC_SIGNALLING_PORT || '3333', 10),
      // webrtcTls: parseInt(
      //   process.env.OME_WEBRTC_SIGNALLING_TLS_PORT || '3334',
      //   10,
      // ),
      tcpRelay: parseInt(process.env.OME_WEBRTC_TCP_RELAY_PORT || '3478', 10),
    },
  },

  appName: process.env.OME_APP_NAME || 'app',
};

export const getOmeConfig = () => {
  return OME_CONFIG;
};
