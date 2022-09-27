from pytest import fixture

path1 = "tests/test_data/movement_video_test.mp4"


@fixture(scope="class")
def processing_movement(get_model):
    m = get_model.movement
    m.fit(path1)

    yield m
