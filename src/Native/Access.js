Elm.Native.Access = {};
Elm.Native.Access.make = function (elm) {
  elm.Native = elm.Native || {};
  elm.Native.Utils = elm.Native.Utils || {};
  _Utils = elm.Native.Utils.values;

  elm.Native.Access = elm.Native.Access || {};
  if (elm.Native.Access.values) {
    return elm.Native.Access.values;
  }

  function makeRecordSetter (getter) {
    var pattern = /return _.([^;]+);/;
    var source = getter.toSource();
    var match = pattern.exec(source);
    var fieldName = match[1];

    return F2(function (newVal, record) {
      return _Utils.replace( [[fieldName, newVal]], record);
    });
  };

  return elm.Native.Access.values = {
    makeRecordSetter : makeRecordSetter
  };

};
