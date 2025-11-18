import express from "express";
import cors from "cors";

const app = express();

app.use(
  cors({
    origin: "*",
  })
);

app.listen(3000, () => {
  console.log("Server started on port 3000");
});

app.get("/v1/livestream/authorize", (req, res) => {
  //   res.send("Hello World!");

  console.log("request came from ", req.ip);
  console.log("request came from ", req.url);

  return res.json(omeAccessResponseBuilder(true));
});
app.post("/v1/livestream/authorize", (req, res) => {
  //   res.send("Hello World!");

  console.log("request came from ", req.ip);
  console.log("request came from ", req.url);

  return res.json(omeAccessResponseBuilder(true));
});

export function omeAccessResponseBuilder(allowed, restParameters = {}) {
  return {
    allowed,
    ...restParameters,
  };
}

// type StreamAuthorizationResult = {
//   allowed: boolean; // Whether the request is authorized
//   new_url?: string; // Possibly rewritten URL (e.g. for routing or CDN)
//   lifetime?: number; // How long the authorization is valid, in milliseconds
//   reason?: string;
// };
