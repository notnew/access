Elm.Native.Access = {};
Elm.Native.Access.make = function (elm) {
  elm.Native = elm.Native || {};
  elm.Native.Utils = elm.Native.Utils || {};
  _Utils = elm.Native.Utils.values;

  elm.Native.Access = elm.Native.Access || {};
  if (elm.Native.Access.values) {
    return elm.Native.Access.values;
  }

  function makeRecordSetter(name) {
    return F2(function ($new, record) {
      return _Utils.replace( [[name, $new]], record);
    });
  };

  return elm.Native.Access.values = {
    makeRecordSetter : makeRecordSetter
  };

};
