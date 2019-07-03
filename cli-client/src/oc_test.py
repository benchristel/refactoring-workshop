import oc
import types

def test_json():
    assert oc.parse_json('{"foo": "bar"}') == dict(foo='bar')
    assert oc.parse_json('["hello", "world"]') == ['hello', 'world']

def test_calling_a_command_and_getting_stdout():
    assert oc.stdout_of(['echo', 'hi']) == 'hi\n'

def test_integration_through_class():
    assert oc.Client().cabbages() == dict()

def test_integration_through_global_function():
    assert oc.cabbages() == dict()
