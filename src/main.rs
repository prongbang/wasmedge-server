use warp::Filter;

#[tokio::main(flavor = "current_thread")]
async fn main() {
    // GET /
    let help = warp::get()
        .and(warp::path::end())
        .map(|| "Hello WasmEdge Server\n");

    // POST /echo
    let echo = warp::post()
        .and(warp::path("echo"))
        .and(warp::body::bytes())
        .map(|body_bytes: bytes::Bytes| {
            format!("{}\n", std::str::from_utf8(body_bytes.as_ref()).unwrap())
        });

    let routes = help.or(echo);
    warp::serve(routes).run(([0, 0, 0, 0], 8080)).await
}