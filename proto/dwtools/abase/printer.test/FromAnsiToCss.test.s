( function _ToFile_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../printer/top/FromAnsiToCss.s' );

  var _ = wTools;

  _.include( 'wTesting' );

}

var _ = wTools;
var Parent = wTools.Testing;
var Self = {};

//

function trivial( test )
{
  let self = this;

  var got;
  let onTransformEnd = function( o ){ got = o };
  let logger = new _.LoggerFromAnsiToCss({ output : null, onTransformEnd : onTransformEnd });

  test.case = 'simple text without styles';
  var src = 'text'
  logger.log( src );
  test.identical( got.outputForTerminal[ 0 ], src );

  test.case = 'red text';
  // var src = _.color.strFormatForeground( 'text', 'red' );
  var src = '\u001b[91mtext\u001b[39;0m';
  logger.log( src );
  var expected = [ '%ctext', 'color:rgba(255,51,0,1);' ];
  test.identical( got.outputForTerminal, expected );

  test.case = 'red text on black background';
  // var src = _.color.strFormatBackground( _.color.strFormatForeground( 'text', 'red' ), 'black' );
  var src = '\u001b[91m\u001b[40mtext\u001b[49;0m\u001b[39;0m';
  logger.log( src );
  var expected = [ '%ctext', 'color:rgba(255,51,0,1);background:rgba(0,0,0,1);' ];
  test.identical( got.outputForTerminal, expected );

  test.case = 'red on black inside yellow text';
  // var src = _.color.strFormatForeground( 'yellow text' + _.color.strFormatBackground( _.color.strFormatForeground( 'red text', 'red' ), 'black' ), 'yellow')
  var src = '\u001b[93myellow text\u001b[39;0m\u001b[91m\u001b[40mred text\u001b[49;0m\u001b[39;0m';
  logger.log( src );
  var expected =
  [
    '%cyellow text%cred text',
    'color:rgba(255,255,0,1);',
    'color:rgba(255,51,0,1);background:rgba(0,0,0,1);'
  ]
  test.identical( got.outputForTerminal, expected );

}

//
``
var Proto =
{

  name : 'Tools/base/printer/ForBrowser',
  silencing : 1,

  tests :
  {
    trivial
  },


}

//

_.mapExtend( Self,Proto );
Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
