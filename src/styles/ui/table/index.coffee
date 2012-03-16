colors = require('styles/theme').colors

module.exports =

  details:
    view:
      borderColor: colors.table.border
      borderRadius: 11
      scrollable: false

    row:
      title:
        view:
          left: 11
          width: '40%'
        label:
          primary:
            height: 17
            font:
              fontWeight: 'bold'
              fontSize: 15
          meta:
            height: 15
      subtitle:
        view:
          right: 11
          width: '40%'
        label:
          primary:
            height: 17
            textAlign: 'right'
            font:
              fontWeight: 'bold'
              fontSize: 15
          meta:
            height: 15
            textAlign: 'right'
