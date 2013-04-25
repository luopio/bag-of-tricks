/*
 KISS solution for a slider

 Usage:
 Put input-elements in code: <input type="text" name="q2" id="q2" value="" />
 call $('#q2').slider({complete: function($inputElement) {}, change: function($inputElement) {}})

 Slider creates a following element structure in DOM:

 <div class="range-slider">
 <div class="handle"></div>
 <div class="value"></div>
 </div>

 Apply extra CSS as desired. Get the value with $inputElement.val(). Will be from 0 to 100;


 Callbacks:
 complete: called when the slider has been released after moving
 change: called when the slider is dragged

 both called with the jquery encapsulated input element as the parameter

 Methods:
 $('input').slider('set', percentage) - sets the value of the slider to percentage

 Author: Lauri Kainulainen / lauri.sokkelo.net

 License: WTFPL (http://www.wtfpl.net/txt/copying/)
 */
(function( $ ){
    $.fn.slider = function(method) {
        var methods = {
            init: function(options) {

                return this.each( function() {
                    var settings = $.extend( {
                        'complete': null,
                        'change': null
                    }, options);

                    // dynamically create the slider element - you'll only need an input in the code
                    var $el = $(this);
                    this.isMoving = false;
                    var parent = $('<div class="range-slider"><div class="handle"></div><div class="value"></div></div>').insertBefore($el);
                    var tmp = $el.remove();
                    parent.append(tmp.hide().val(50));
                    this.el = parent;

                    var self = this;
                    this.handle = this.el.find('.handle');

                    this.handle.on('touchstart mousedown', function(e) {
                        e.preventDefault();
                        self.isMoving = true;
                        return false;
                    });

                    this.el.on('click', function(e) {

                        if(!self.isMoving && e.target != self.handle[0]) {
                            if(e.changedTouches) {
                                var t = e.changedTouches[0];
                                var x = t.pageX; var y = t.pageY;
                            } else {
                                var x = e.pageX; var y = e.pageY;
                            }
                            var pos = self.el.offset();
                            var width = self.el.width() - 30;
                            var perc = Math.min( Math.max(0, x - pos.left - 15), width) / width;
                            self.el.slider('set', perc * 100);
                            if(settings.change) {
                                // TODO: not called on external set.. should fix, but how to get the context into set()?
                                settings.change(self.el.find('input'));
                            }
                            if(settings.complete) {
                                settings.complete(self.el.find('input'));
                            }
                        }
                    });

                    $(document).on('touchstop mouseup', function(e) {
                        if(self.isMoving && settings.complete) {
                            settings.complete(self.el.find('input'));
                        }
                        self.isMoving = false;
                    });

                    $(document).on('mousemove touchmove', function(e) {
                        if(self.isMoving && self.el) {
                            e.preventDefault();
                            if(e.changedTouches) {
                                var t = e.changedTouches[0];
                                var x = t.pageX; var y = t.pageY;
                            } else {
                                var x = e.pageX; var y = e.pageY;
                            }
                            var pos = self.el.offset();
                            var width = self.el.width() - 30;
                            var perc = Math.min( Math.max(0, x - pos.left - 15), width) / width;
                            self.el.slider('set', perc * 100);
                            if(settings.change) {
                                // TODO: not called on external set.. should fix, but how to get the context into set()?
                                settings.change(self.el.find('input'));
                            }
                            return false;
                        }
                    });
                });
            },

            set: function(percentage) {
                var $element = this;
                if(!$element.hasClass('range-slider')) { $element = $element.parent(); }
                if(!$element.hasClass('range-slider')) { alert('not a range slider or a child of range-slider element: ', $element); return false; }
                var width = $element.width() - 30;
                var roundedPercentage = Math.round(percentage);
                $element.find('.handle').css('left', 15 + (roundedPercentage / 100.0 * width - 15) + 'px');
                $element.find('.value').text(roundedPercentage);
                $element.find('input').val(roundedPercentage);
                return true;
            }
        }

        if( methods[method] ) {
            return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
        } else if( typeof method === 'object' || ! method ) {
            return methods.init.apply( this, arguments );
        } else {
            $.error( 'Method ' +  method + ' does not exist on jQuery.slider' );
        }

    };
})( jQuery );