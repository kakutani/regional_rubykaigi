/**
 * Sexy LightBox - for mootools 1.2.3
 * @name      sexylightbox.v2.3.js
 * @author    Eduardo D. Sada - http://www.coders.me/web-html-js-css/javascript/sexy-lightbox-2
 * @version   2.3.3
 * @date      30-Oct-2009
 * @copyright (c) 2009 Eduardo D. Sada (www.coders.me)
 * @license   MIT - http://es.wikipedia.org/wiki/Licencia_MIT
 * @example   http://www.coders.me/ejemplos/sexy-lightbox-2/
*/

Element.implement({
	css: function(params){ return this.setStyles(params);} // costumbre jQuery
});

var SexyLightBox = new Class(
{
  Implements: [Options, Events],
	getOptions: {
    name          : 'SLB',
    zIndex        : 32000,
    color         : 'black',
    find          : 'sexylightbox',
    dir           : 'sexylightbox/sexyimages',
    emergefrom    : 'top',
    background    : 'bgSexy.png',
    backgroundIE  : 'bgSexy.gif',
    buttons       : 'buttons.png',
    displayed     : 0,
    showDuration  : 200,
    showEffect    : Fx.Transitions.linear,
    closeDuration : 400,
    closeEffect   : Fx.Transitions.linear,
    moveDuration  : 1000,
    moveEffect    : Fx.Transitions.Back.easeInOut,
    resizeDuration: 1000,
    resizeEffect  : Fx.Transitions.Back.easeInOut,
    shake         : {
                      distance   : 10,
                      duration   : 100,
                      transition : Fx.Transitions.Sine.easeInOut,
                      loops      : 2
                    },
    BoxStyles     : { 'width' : 486, 'height': 320 },
    Skin          : {
                      'white' : { 'hexcolor': '#FFFFFF', 'captionColor': '#000000', 'background-color': '#000000', 'opacity': 0.6 },
                      'black' : { 'hexcolor': '#000000', 'captionColor': '#FFFFFF', 'background-color': '#000000', 'opacity': 0.6 },
                      'blanco': { 'hexcolor': '#FFFFFF', 'captionColor': '#000000', 'background-color': '#000000', 'opacity': 0.6 },
                      'negro' : { 'hexcolor': '#000000', 'captionColor': '#FFFFFF', 'background-color': '#000000', 'opacity': 0.6 }
                    }
	},
  
  overlay: {
    create: function(options) {
      this.options = options;
      this.element = new Element('div', {
        id      : 'mask-' + $time(),
        styles  : $merge(this.options.style, {
          'position'  : 'absolute',
          'top'       : 0,
          'left'      : 0,
          'opacity'   : 0,
          'z-index'   : this.options.zIndex
        }),
        events  : {
            click: function() {
              if (this.options.hideOnClick) {
                  if (this.options.callback) {
                    this.options.callback();
                  } else {
                    this.hide();
                  }
              }
            }.bind(this)
        } // events
      });
      
      this.hidden = true;
      this.inject();
    },

    inject: function() {
      this.target = document.id(document.body);
      this.element.inject(this.target, 'inside');

      if((Browser.Engine.trident4 || (Browser.Engine.gecko && !Browser.Engine.gecko19 && Browser.Platform.mac)))
      {
        var zIndex = this.element.getStyle('zIndex').toInt();
        if (!zIndex)
        {
          zIndex = 1;
          var pos = this.element.getStyle('position');
          if (pos == 'static' || !pos)
          {
            this.element.setStyle('position', 'relative');
          }
          this.element.setStyle('zIndex', zIndex);
        }
        zIndex = ($chk(this.options.zIndex) && zIndex > this.options.zIndex) ? this.options.zIndex : zIndex - 1;
        if (zIndex < 0)
        {
          zIndex = 1;
        }
        this.shim = new Element('iframe', {
          id          : "IF_"+new Date().getTime(),
          src         : '',
          scrolling   : 'no',
          frameborder : 0,
          styles      :
          {
            zIndex    : zIndex,
            position  : 'absolute',
            top       : 0,
            left      : 0,
            border    : 'none',
            opacity   : 0
          }
        });
        this.shim.inject(this.element, 'after');
      }

    },

    resize: function(x, y) {
      this.element.setStyles({ 'height': 0, 'width': 0 });
      if (this.shim) this.shim.setStyles({ 'height': 0, 'width': 0 });

      var win = window.getScrollSize();
      var chromebugfix = Browser.Engine.webkit ? (win.x - 25 < document.html.clientWidth ? document.html.clientWidth : win.x) : win.x;

      this.element.setStyles({
        width  : $pick(x, chromebugfix), //* chrome fix
        height : $pick(y, win.y)
      });
      
      if (this.shim)
      {
        this.shim.setStyles({ 'height': 0, 'width': 0 });

        this.shim.setStyles({
          width  : $pick(x, Math.max(win.x, document.html.clientWidth)), //* chrome fix
          height : $pick(y, win.y)
        });
      }
      return this;
    },

    show: function() {
      if (!this.hidden) return this;
      if (this.transition) this.transition.cancel();
      this.target.addEvent('resize', this.resize);
      this.resize();
      if (this.shim) this.shim.setStyle('display', 'block');
      this.hidden = false;
      
      this.transition = new Fx.Tween(this.element, {
        property   : 'opacity',
        duration   : this.options.showDuration,
        transition : this.options.showEffect,
        onComplete : function () { this.element.fireEvent('show'); }.bind(this)
      }).start(this.options.style.opacity);

      return this;
    },

    hide: function() {
      if (this.hidden) return this;
      if (this.transition) this.transition.cancel();
      this.target.removeEvent('resize', this.resize);
      if (this.shim) this.shim.setStyle('display', 'none');
      this.hidden = true;

      this.transition = new Fx.Tween(this.element, {
          property    : 'opacity',
          duration    : this.options.closeDuration,
          transition  : this.options.closeEffect,
          onComplete  : function() { 
            this.element.setStyles({ 'height': 0, 'width': 0 });
            this.element.fireEvent('hide');
          }.bind(this)
      }).start(0);


      return this;
    }

  },
  
  backwardcompatibility: function(option) {
    this.options.dir =  option.imagesdir || option.path || option.folder || option.dir;
    this.options.OverlayStyles = $extend(this.options.Skin[this.options.color], this.options.OverlayStyles || {});
  },
  
  preloadimage: function(url) {
    img     = new Image();
    img.src = url;
  },
  
	initialize: function(options) {
    this.setOptions(this.getOptions, options);
    this.backwardcompatibility(this.options);
        
    var strBG = this.options.dir+'/'+this.options.color+'/'+((Browser.Engine.trident4)?this.options.backgroundIE:this.options.background);
    var name  = this.options.name;
    
    this.preloadimage(strBG);
    this.preloadimage(this.options.dir+'/'+this.options.color+'/'+this.options.buttons);
    
    this.overlay.create({
      style       : this.options.Skin[this.options.color],
      hideOnClick : true,
      zIndex      : this.options.zIndex-1,
      callback    : this.close.bind(this),
      showDuration  : this.options.showDuration,
      showEffect    : this.options.showEffect,
      closeDuration : this.options.closeDuration,
      closeEffect   : this.options.closeEffect
    });

    this.lightbox = {};
 
    this.Wrapper = new Element('div', { 
      'id'      : name + '-Wrapper',
      'styles'  : {
        'z-index'   : this.options.zIndex,
        'display'   : 'none'
      }
    });
    
    this.Background = new Element('div', {
      'id'      : name + '-Background',
      'styles': {
        'z-index'   : this.options.zIndex + 1
      }
    }).injectInside(this.Wrapper);
    
    this.Contenedor = new Element('div', {
      'id'      : name + '-Contenedor',
      'styles'  : {
        'position'  : 'absolute',
        'width'     : this.options.BoxStyles['width'],
        'z-index'   : this.options.zIndex + 2
      }
    }).injectInside(this.Wrapper);

    
    this.Top = new Element('div', {id: name+'-Top', styles:{'background-image':'url('+strBG+')'}}).injectInside(this.Contenedor);
    
    this.CloseButton = new Element('a', {href:'#', html:'&nbsp;', styles:{'background-image': 'url('+this.options.dir+'/'+this.options.color+'/'+this.options.buttons+')'}}).injectInside(this.Top);
    new Element('div', {'id': name+'-TopLeft', 'styles': {'background-image':'url('+strBG+')'}}).injectInside(this.Top);
    
    this.Contenido = new Element('div', {
      'id'      : name + '-Contenido',
      'styles'  : {
        'height'            : this.options.BoxStyles['height'],
        'border-left-color' : this.options.Skin[this.options.color].hexcolor,
        'border-right-color': this.options.Skin[this.options.color].hexcolor
      }
    }).injectInside(this.Contenedor);

    this.bb          = new Element('div', {'id': name + '-Bottom'      , 'styles':{'background-image':'url('+strBG+')'}}).injectInside(this.Contenedor);
    this.innerbb     = new Element('div', {'id': name + '-BottomRight' , 'styles':{'background-image':'url('+strBG+')'}}).injectInside(this.bb);
    this.Nav         = new Element('div', {'id': name + '-Navegador'   , 'styles':{'color':this.options.Skin[this.options.color].captionColor}});
    this.Descripcion = new Element('strong',{'id': name + '-Caption'   , 'styles':{'color':this.options.Skin[this.options.color].captionColor}});

    this.Wrapper.injectInside(document.body);
  
    /**
     * AGREGAMOS LOS EVENTOS
     ************************/

    this.CloseButton.addEvent('click', function() {
      this.close();
      return false;
    }.bind(this));

    document.addEvent('keydown', function(event) {
      if (this.options.displayed == 1) {
        if (event.key == 'esc'){
          this.close();
        }

        if (event.key == 'left'){
          if (this.prev) {
            this.prev.fireEvent('click', event);
          }
        }

        if (event.key == 'right'){
          if (this.next) {
            this.next.fireEvent('click', event);
          }
        }
      }
    }.bind(this));


    window.addEvents({
        'resize': function() {
            if (this.options.displayed == 1)
            {
              this.replaceBox();
              this.overlay.resize();
            }
        }.bind(this),
        
        'scroll': function() {
            if (this.options.displayed == 1)
            {
              this.replaceBox();
            }          
        }.bind(this)
    });
    
    this.refresh();

    this.MoveBox = $empty();
	
  },

  hook: function(enlace) {
    enlace.blur();
    this.show((enlace.title || enlace.name || ""), enlace.href, (enlace.getProperty('rel') || false));
  },

  close: function() {
    this.animate(0);
  },
  
  refresh: function() {
    this.anchors = [];
    $$("a", "area").each(function(el) {
      if (el.getProperty('rel') && el.getProperty('rel').test("^"+this.options.find)) {
        el.addEvent('click', function() {
          this.hook(el);
          return false;
        }.bind(this));
        if (!(el.getProperty('id')==this.options.name+"-Left" || el.getProperty('id')==this.options.name+"-Right")) {
          this.anchors.push(el);
        }
      }
    }.bind(this));
  },

  animate: function(option) {
      // Mostrar el Lightbox
      if(this.options.displayed == 0 && option != 0 || option == 1)
      {
        this.overlay.show();
        this.options.displayed = 1;
        this.Wrapper.css({'display': 'block'});
      }
      else // Cerrar el Lightbox
      {
        this.Wrapper.css({
          'display' : 'none',
          'top'     : -(this.options.BoxStyles['height']+280)
        });
        
        this.overlay.hide();
        this.overlay.element.addEvent('hide', function() {
          if (this.options.displayed) {
            if (this.Image) this.Image.dispose();
            this.options.displayed = 0;
          }
        }.bind(this));
      }
  },
  
  
	/*
	Function: replaceBox
  @description  Cambiar de tama¡¦ y posicionar el lightbox en el centro de la pantalla
	*/
	replaceBox: function(data) {
      var size   = window.getSize();
      var scroll = window.getScroll();
      var width  = this.options.BoxStyles['width'];
      var height = this.options.BoxStyles['height'];

      if (this.options.displayed == 0)
      {
        var x = 0;
        var y = 0;
        
        // vertically center
        y = scroll.x + ((size.x - width) / 2);

        if (this.options.emergefrom == "bottom")
        {
          x = (scroll.y + size.y + 80);
        }
        else // top
        {
          x = (scroll.y - height) - 80;
        }
      
        this.Wrapper.css({
          'display' : 'none',
          'top'     : x,
          'left'    : y
        });
        this.Contenedor.css({
          'width'   : width
        });
        this.Contenido.css({
          'height'  : height - 80
        });
      }

      data = $extend({
        'width'  : this.lightbox.width,
        'height' : this.lightbox.height,
        'resize' : 0
      }, data || {});

      if (this.MoveBox) this.MoveBox.cancel();

      this.MoveBox = new Fx.Morph(this.Wrapper, {
        duration   : this.options.moveDuration,
        transition : this.options.moveEffect
      }).start({
        'left': (scroll.x + ((size.x - data.width) / 2)),
        'top' : (scroll.y + (size.y - (data.height + (this.navigator ? 80 : 48))) / 2)
      });

      if (data.resize)
      {
        if (this.ResizeBox2) this.ResizeBox2.cancel();
        this.ResizeBox2 = new Fx.Morph(this.Contenido, {
          duration   : this.options.resizeDuration,
          transition : this.options.resizeEffect
        }).start({ 'height': data.height });

        if (this.ResizeBox) this.ResizeBox.cancel(); 
        this.ResizeBox = new Fx.Morph(this.Contenedor, {
          duration   : this.options.resizeDuration,
          transition : this.options.resizeEffect
        }).start({ 'width': data.width });
      }
      
	},
	
  getInfo: function (image, id) {
      return new Element('a', {
        id    : this.options.name+'-'+id,
        title : image.title,
        href  : image.href,
        rel   : image.getProperty('rel'),
        html  : "&nbsp;",
        styles: {
          'background-image' : 'url('+this.options.dir+'/'+this.options.color+'/'+this.options.buttons+')'
        }
      });

  },
  
	/*
	Function: display
	@description  Preparar y mostrar el lightbox.
	*/
  display: function(url, title, force) {
    return this.show(title, url, '', force);
  },

  show: function(caption, url, rel, force) {
      this.showLoading();
      
      var baseURL     = url.match(/(.+)?/)[1] || url;
      var imageURL    = /\.(jpe?g|png|gif|bmp)/gi;
      var queryString = url.match(/\?(.+)/);
      if (queryString) queryString = queryString[1];
      var params      = this.parseQuery( queryString );
      
      params = $merge({
        'width'     : 0,
        'height'    : 0,
        'modal'     : 0,
        'background': '',
        'title'     : caption
      }, params || {});

      params['width']   = params['width'].toInt();
      params['height']  = params['height'].toInt();
      params['modal']   = params['modal'].toInt();

      this.overlay.options.hideOnClick = !params['modal'];

      this.lightbox  = $merge(params, { 'width' : params['width'] + 14 });
      this.navigator = this.lightbox.title ? true : false;

      if ( force=='image' || baseURL.match(imageURL) )
      {
          this.img = new Image();
          this.img.onload = function() {
              this.img.onload=function(){};
              if (!params['width'])
              {
                var objsize = this.calculate(this.img.width, this.img.height);
                params['width']   = objsize.x;
                params['height']  = objsize.y;
                this.lightbox.width = params['width'] + 14;
              }
              this.lightbox.height = params['height'] - (this.navigator ? 21 : 35);
              
              this.replaceBox({ 'resize' : 1 });
              
              // Mostrar la imagen, solo cuando la animacion de resizado se ha completado
              this.ResizeBox.addEvent('complete', function() {
                this.showImage(this.img.src, params);
              }.bind(this));
          }.bind(this);
          
          this.img.onerror = function() {
            this.show('', this.options.dir+'/'+this.options.color+'/404.png', this.options.find);
          }.bind(this);
          
          this.img.src = url;

      } else { //code to show html pages

        this.lightbox.height = params['height']+(Browser.Engine.presto?2:0);
        this.replaceBox({'resize' : 1});

        if (url.indexOf('TB_inline') != -1) //INLINE ID
        {
          this.ResizeBox.addEvent('complete', function() {
            this.showContent($(params['inlineId']).get('html'), this.lightbox);
          }.bind(this));
        }
        else if(url.indexOf('TB_iframe') != -1) //IFRAME
        {
          var urlNoQuery = url.split('TB_');
          this.ResizeBox.addEvent('complete', function() {
            this.showIframe(urlNoQuery[0], this.lightbox);
          }.bind(this));
        }
        else //AJAX
        {
          this.ResizeBox.addEvent('complete', function() {
            var myRequest = new Request.HTML({
              url         : url,
              method      : 'get',
              evalScripts : false,
              onFailure   : function (xhr) {if(xhr.status==404){this.show('', this.options.dir+'/'+this.options.color+'/404html.png', this.options.find)}}.bind(this),
              onSuccess   : this.handlerFunc.bind(this)
            }).send();
          }.bind(this));
        }
      }
      
      this.next = false;
      this.prev = false;
      // Si la imagen pertenece a un grupo
      if (rel.length > this.options.find.length)
      {
          this.navigator = true;
          var foundSelf  = false;
          var exit       = false;

          this.anchors.each( function(image, index) {
            if (image.getProperty('rel') == rel && !exit) {
                if (image.href == url) {
                    foundSelf = true;
                } else {
                    if (foundSelf) {
                        this.next = this.getInfo(image, "Right");
                        // stop searching
                        exit = true;
                    } else {
                        this.prev = this.getInfo(image, "Left");
                    }
                }
            }
          }.bind(this));
      }

      this.addButtons();
      this.showNavBar(caption);
      this.animate(1);
  },
  
  calculate: function(x, y) {
    // Resizing large images
    var maxx = window.getWidth() - 100;
    var maxy = window.getHeight() - 100;

    if (x > maxx)
    {
      y = y * (maxx / x);
      x = maxx;
      if (y > maxy)
      {
        x = x * (maxy / y);
        y = maxy;
      }
    }
    else if (y > maxy)
    {
      x = x * (maxy / y);
      y = maxy;
      if (x > maxx)
      {
        y = y * (maxx / x);
        x = maxx;
      }
    }
    // End Resizing
    return {x: x.toInt(), y: y.toInt()};
  },
  
  handlerFunc: function(tree, elements, html, script) {
    this.showContent(html, this.lightbox);
    $exec(script);
  },

  addButtons: function(){
      if(this.prev) this.prev.addEvent('click', function(event) {event.stop();this.hook(this.prev);}.bind(this));
      if(this.next) this.next.addEvent('click', function(event) {event.stop();this.hook(this.next);}.bind(this));
  },
  
  showNavBar: function() {
      if (this.navigator)
      {
        this.bb.addClass("SLB-bbnav");
        this.Nav.empty();
        this.Nav.injectInside(this.innerbb);
        this.Descripcion.set('html', this.lightbox.title);
        this.Nav.adopt(this.prev);
        this.Nav.adopt(this.next);
        this.Descripcion.injectInside(this.Nav);
      }
      else
      {
        this.bb.removeClass("SLB-bbnav");
        this.innerbb.empty();
      }
  },
  
  showImage: function(image, size) {
    this.Image = new Element('img', { 'src' : image, 'styles': size}).injectInside(
      this.Background.empty().erase('style').css({width:'auto', height:'auto'})
    );

    this.Contenedor.css({
      'background' : 'none'
    });

    this.Contenido.empty().css({
        'background-color': 'transparent',
        'padding'         : '0px',
        'width'           : 'auto'
    });
  },

  showContent: function(html, size) {
    this.Background.css({
      'width'            : size['width']-14,
      'height'           : size['height']+35,
      'background-color' : size['background'] || '#ffffff'
    });
    this.Image = new Element('div', { 'styles': {
      'width'       : size['width']-14,
      'height'      : size['height'],
      'overflow'    : 'auto',
      'background'  : size['background'] || '#ffffff'
    }}).set('html', html).injectInside(this.Contenido.empty().css({
      'width'             : size['width']-14,
      'background-color'  : size['background'] || '#ffffff'
    }));
    this.Contenedor.css({
      'background': 'none'
    });
  },

  showIframe: function(src, size) {
    this.Background.css({
      'width'           : size['width']-14,
      'height'          : size['height']+35,
      'background-color': size['background'] || '#ffffff'
    });
  
    this.Image = new Element('iframe', {
      'frameborder' : 0,
      'id'          : "IF_"+new Date().getTime(),
      'styles'      : {
        'width'       : size['width']-14,
        'height'      : size['height'],
        'background'  : size['background'] || '#ffffff'
      }
    }).set('src',src).injectInside(this.Contenido.empty().css({
      'width'             : size['width']-14,
      'background-color'  : size['background'] || '#ffffff',
      'padding'           : '0px'
    }));
    this.Contenedor.css({
      'background' : 'none'
    });
  },

  showLoading: function() {
    this.Background.empty().erase('style').css({width:'auto', height:'auto'});

    this.Contenido.empty().css({
      'background-color'  : 'transparent',
      'padding'           : '0px',
      'width'             : 'auto'
    });

    this.Contenedor.css({
      'background' : 'url('+this.options.dir+'/'+this.options.color+'/loading.gif) no-repeat 50% 50%'
    });

    this.replaceBox($merge(this.options.BoxStyles, {'resize' : 1}));
  },

  parseQuery: function (query) {
    if( !query )
      return {};
    var params = {};

    var pairs = query.split(/[;&]/);
    for ( var i = 0; i < pairs.length; i++ ) {
      var pair = pairs[i].split('=');
      if ( !pair || pair.length != 2 )
        continue;
      params[unescape(pair[0])] = unescape(pair[1]).replace(/\+/g, ' ');
     }
     return params;
  },
  
  shake: function() {
		var d = this.options.shake.distance;
		var l = this.Wrapper.getCoordinates();
		l = l.left;
		if (!this.tween)
		{
      this.tween = new Fx.Tween(this.Wrapper, { 
        link       : 'chain', 
        duration   : this.options.shake.duration,
        transition : this.options.shake.transition
      });
		}
		for(x=0;x<this.options.shake.loops;x++)
		{
      this.tween.start('left',l+d).start('left',l-d);
		}
		this.tween.start('left',l+d).start('left',l);
  }
  
});