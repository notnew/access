Elm.Native.Access = {};
Elm.Native.Access.make = function (elm) {

  elm.Native = elm.Native || {};
  elm.Native.Access = elm.Native.Access || {};

  if (elm.Native.Access.values) {
    return elm.Native.Access.values;
  }

  _Utils = Elm.Native.Utils.make(elm);
  _Debug = Elm.Debug.make(elm);

  function makeRecordSetter (getter, newVal, record) {
    var pattern = /return _.([^;]+);/;
    var source = getter.toString();
    var match = pattern.exec(source);
    if (match === null || match.length < 2) {
      var msg =
          "Access.Native.makeRecordSetter: " +
          "could not get field name from getter\n" +
          "Only call this function directly with builtin record accessor " +
          "functions such as\n" +
          "   .x\n" +
          "   .field";
      _Debug.crash(msg);
    }

    var fieldName = match[1];

    return _Utils.replace( [[fieldName, newVal]], record);
  };

  return elm.Native.Access.values = {
    makeRecordSetter : F3(makeRecordSetter)
  };

};
