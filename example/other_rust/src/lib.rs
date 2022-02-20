use gdnative::prelude::*;

use std::time::SystemTime;

fn init(handle: InitHandle) {
    handle.add_class::<Ponger>();
}

godot_init!(init);

#[derive(NativeClass)]
#[inherit(Reference)]
struct Ponger;

#[methods]
impl Ponger {
    fn new(_: &Reference) -> Self {
        Ponger
    }

    #[export]
    fn ping(&self, _: &Reference) -> String {
        "world".to_string()
    }

    #[export]
    fn count_up_unix_time(&self, _: &Reference) -> i64 {
        SystemTime::now()
            .duration_since(SystemTime::UNIX_EPOCH)
            .expect("Unable to get unix time")
            .as_secs() as i64
    }
}
