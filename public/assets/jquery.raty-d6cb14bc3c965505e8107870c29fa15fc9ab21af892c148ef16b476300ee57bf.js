/*!
 * jQuery Raty - A Star Rating Plugin
 *
 * The MIT License
 *
 * @author  : Washington Botelho
 * @doc     : http://wbotelhos.com/raty
 * @version : 2.7.1
 *
 */

;(function($) {
  'use strict';

  var methods = {
    init: function(options) {
      return this.each(function() {
        this.self = $(this);

        methods.destroy.call(this.self);

        this.opt = $.extend(true, {}, $.fn.raty.defaults, options);

        methods._adjustCallback.call(this);
        methods._adjustNumber.call(this);
        methods._adjustHints.call(this);

        this.opt.score = methods._adjustedScore.call(this, this.opt.score);

        if (this.opt.starType !== 'img') {
          methods._adjustStarType.call(this);
        }

        methods._adjustPath.call(this);
        methods._createStars.call(this);

        if (this.opt.cancel) {
          methods._createCancel.call(this);
        }

        if (this.opt.precision) {
          methods._adjustPrecision.call(this);
        }

        methods._createScore.call(this);
        methods._apply.call(this, this.opt.score);
        methods._setTitle.call(this, this.opt.score);
        methods._target.call(this, this.opt.score);

        if (this.opt.readOnly) {
          methods._lock.call(this);
        } else {
          this.style.cursor = 'pointer';

          methods._binds.call(this);
        }
      });
    },

    _adjustCallback: function() {
      var options = ['number', 'readOnly', 'score', 'scoreName', 'target', 'path'];

      for (var i = 0; i < options.length; i++) {
        if (typeof this.opt[options[i]] === 'function') {
          this.opt[options[i]] = this.opt[options[i]].call(this);
        }
      }
    },

    _adjustedScore: function(score) {
      if (!score) {
        return score;
      }

      return methods._between(score, 0, this.opt.number);
    },

    _adjustHints: function() {
      if (!this.opt.hints) {
        this.opt.hints = [];
      }

      if (!this.opt.halfShow && !this.opt.half) {
        return;
      }

      var steps = this.opt.precision ? 10 : 2;

      for (var i = 0; i < this.opt.number; i++) {
        var group = this.opt.hints[i];

        if (Object.prototype.toString.call(group) !== '[object Array]') {
          group = [group];
        }

        this.opt.hints[i] = [];

        for (var j = 0; j < steps; j++) {
          var hint = group[j],
              last = group[group.length - 1];

          if (last === undefined) {
            last = null;
          }

          this.opt.hints[i][j] = hint === undefined ? last : hint;
        }
      }
    },

    _adjustNumber: function() {
      this.opt.number = methods._between(this.opt.number, 1, this.opt.numberMax);
    },

    _adjustPath: function() {
      this.opt.path = this.opt.path || '';

      if (this.opt.path && this.opt.path.charAt(this.opt.path.length - 1) !== '/') {
        this.opt.path += '/';
      }
    },

    _adjustPrecision: function() {
      this.opt.half = true;
    },

    _adjustStarType: function() {
      var replaces = ['cancelOff', 'cancelOn', 'starHalf', 'starOff', 'starOn'];

      this.opt.path = '';

      for (var i = 0; i < replaces.length; i++) {
        this.opt[replaces[i]] = this.opt[replaces[i]].replace('.', '-');
      }
    },

    _apply: function(score) {
      methods._fill.call(this, score);

      if (score) {
        if (score > 0) {
          this.score.val(score);
        }

        methods._roundStars.call(this, score);
      }
    },

    _between: function(value, min, max) {
      return Math.min(Math.max(parseFloat(value), min), max);
    },

    _binds: function() {
      if (this.cancel) {
        methods._bindOverCancel.call(this);
        methods._bindClickCancel.call(this);
        methods._bindOutCancel.call(this);
      }

      methods._bindOver.call(this);
      methods._bindClick.call(this);
      methods._bindOut.call(this);
    },

    _bindClick: function() {
      var that = this;

      that.stars.on('click.raty', function(evt) {
        var execute = true,
            score = (that.opt.half || that.opt.precision) ? that.self.data('score') : (this.alt || $(this).data('alt'));

        if (that.opt.click) {
          execute = that.opt.click.call(that, +score, evt);
        }

        if (execute || execute === undefined) {
          if (that.opt.half && !that.opt.precision) {
            score = methods._roundHalfScore.call(that, score);
          }

          methods._apply.call(that, score);
        }
      });
    },

    _bindClickCancel: function() {
      var that = this;

      that.cancel.on('click.raty', function(evt) {
        that.score.removeAttr('value');

        if (that.opt.click) {
          that.opt.click.call(that, null, evt);
        }
      });
    },

    _bindOut: function() {
      var that = this;

      that.self.on('mouseleave.raty', function(evt) {
        var score = +that.score.val() || undefined;

        methods._apply.call(that, score);
        methods._target.call(that, score, evt);
        methods._resetTitle.call(that);

        if (that.opt.mouseout) {
          that.opt.mouseout.call(that, score, evt);
        }
      });
    },

    _bindOutCancel: function() {
      var that = this;

      that.cancel.on('mouseleave.raty', function(evt) {
        var icon = that.opt.cancelOff;

        if (that.opt.starType !== 'img') {
          icon = that.opt.cancelClass + ' ' + icon;
        }

        methods._setIcon.call(that, this, icon);

        if (that.opt.mouseout) {
          var score = +that.score.val() || undefined;

          that.opt.mouseout.call(that, score, evt);
        }
      });
    },

    _bindOver: function() {
      var that = this,
          action = that.opt.half ? 'mousemove.raty' : 'mouseover.raty';

      that.stars.on(action, function(evt) {
        var score = methods._getScoreByPosition.call(that, evt, this);

        methods._fill.call(that, score);

        if (that.opt.half) {
          methods._roundStars.call(that, score, evt);
          methods._setTitle.call(that, score, evt);

          that.self.data('score', score);
        }

        methods._target.call(that, score, evt);

        if (that.opt.mouseover) {
          that.opt.mouseover.call(that, score, evt);
        }
      });
    },

    _bindOverCancel: function() {
      var that = this;

      that.cancel.on('mouseover.raty', function(evt) {
        var starOff = that.opt.path + that.opt.starOff,
            icon = that.opt.cancelOn;

        if (that.opt.starType === 'img') {
          that.stars.attr('src', starOff);
        } else {
          icon = that.opt.cancelClass + ' ' + icon;

          that.stars.attr('class', starOff);
        }

        methods._setIcon.call(that, this, icon);
        methods._target.call(that, null, evt);

        if (that.opt.mouseover) {
          that.opt.mouseover.call(that, null);
        }
      });
    },

    _buildScoreField: function() {
      return $('<input />', { name: this.opt.scoreName, type: 'hidden' }).appendTo(this);
    },

    _createCancel: function() {
      var icon = this.opt.path + this.opt.cancelOff,
          cancel = $('<' + this.opt.starType + ' />', { title: this.opt.cancelHint, 'class': this.opt.cancelClass });

      if (this.opt.starType === 'img') {
        cancel.attr({ src: icon, alt: 'x' });
      } else {
        cancel.attr('data-alt', 'x').addClass(icon);
      }

      if (this.opt.cancelPlace === 'left') {
        this.self.prepend('&#160;').prepend(cancel);
      } else {
        this.self.append('&#160;').append(cancel);
      }

      this.cancel = cancel;
    },

    _createScore: function() {
      var score = $(this.opt.targetScore);

      this.score = score.length ? score : methods._buildScoreField.call(this);
    },

    _createStars: function() {
      for (var i = 1; i <= this.opt.number; i++) {
        var name = methods._nameForIndex.call(this, i),
            attrs = { alt: i, src: this.opt.path + this.opt[name] };

        if (this.opt.starType !== 'img') {
          attrs = { 'data-alt': i, 'class': attrs.src };
        }

        attrs.title = methods._getHint.call(this, i);

        $('<' + this.opt.starType + ' />', attrs).appendTo(this.self);

        if (this.opt.space) {
          this.self.append(i < this.opt.number ? '&#160;' : '');
        }
      }

      this.stars = this.self.children(this.opt.starType);
    },

    _error: function(message) {
      $(this).text(message);

      $.error(message);
    },

    _fill: function(score) {
      var hash = 0;

      for (var i = 1; i <= this.stars.length; i++) {
        var icon,
            star = this.stars[i - 1];

        if (this.opt.iconRange && this.opt.iconRange.length > hash) {
          var irange = this.opt.iconRange[hash];

          icon = methods._getRangeIcon.call(this, irange, i);

          if (i <= irange.range) {
            methods._setIcon.call(this, star, icon);
          }

          if (i === irange.range) {
            hash++;
          }
        } else {
          icon = this.opt[i <= score ? 'starOn' : 'starOff'];

          methods._setIcon.call(this, star, icon);
        }
      }
    },

    _getHint: function(score, evt) {
      if (score !== 0 && !score) {
        return this.opt.noRatedMsg;
      }

      var group = this.opt.hints[(score - 1)] || this.opt.hints[0],
          hint = group[0];

      if (evt && this.opt.precision) {
        hint = methods._getPrecisionHint.call(this, group, score, evt);
      } else if (score % 1 !== 0) {
        hint = group[this.opt.halfShow ? 1 : 0];
      }

      return hint === '' ? '' : hint || score;
    },

    _getPrecisionHint: function(group, score, evt) {
      var decimal = methods._getFirstDecimal.call(this, score),
          name = decimal ? methods._getDecimalNameFromPosition.call(this, evt) : 0;

      return group[name] || group[0];
    },

    _getFirstDecimal: function(number) {
      var decimal = number.toString().split('.')[1];

      return decimal ? parseInt(decimal.charAt(0), 10) : 0;
    },

    _getRangeIcon: function(irange, i) {
      return this.opt[i <= irange.range ? 'starOn' : 'starOff'];
    },

    _getScoreByPosition: function(evt, icon) {
      var score = parseInt(icon.alt || icon.getAttribute('data-alt'), 10);

      if (this.opt.half) {
        var size = methods._getWidth.call(this);

        var percent = ((evt.pageX - $(icon).offset().left) / size).toFixed(2),
            diff = 0.5;

        if (this.opt.precision) {
          diff = 0.1;
        }

        score = score - 1 + diff + percent;
      }

      return score;
    },

    _getWidth: function() {
      return this.stars[0].width || parseFloat(this.stars.eq(0).css('font-size'));
    },

    _lock: function() {
      var hint = this.score.val();

      this.style.cursor = '';
      this.title = methods._getHint.call(this, +hint);

      this.score.attr('readonly', 'readonly');
      this.stars.attr('title', this.title);

      if (this.cancel) {
        this.cancel.hide();
      }
    },

    _nameForIndex: function(i) {
      return i % 2 === 0 ? 'starOff' : 'starOn';
    },

    _resetTitle: function() {
      for (var i = 1; i <= this.stars.length; i++) {
        this.stars[i - 1].title = methods._getHint.call(this, i);
      }
    },

    _roundStars: function(score, evt) {
      var name = methods._nameForIndex.call(this, Math.ceil(score));

      if (score % 1 !== 0) {
        var width = methods._getWidth.call(this),
            percent = evt ? methods._getPosition.call(this, evt, width) : methods._getHalfWidth.call(this, width),
            diff = percent === 1 ? -1 : 1;

        name = methods._nameForIndex.call(this, Math.ceil(score) + diff);
      }

      methods._setIcon.call(this, this.stars[Math.ceil(score) - 1], name);
    },

    _setIcon: function(star, name) {
      star.src = this.opt.path + name;

      if (this.opt.starType !== 'img') {
        $(star).attr('class', name);
      }
    },

    _setTarget: function(score, evt) {
      if (this.opt.target) {
        var target = $(this.opt.target);

        if (!target.length) {
          methods._error.call(this, 'Target selector invalid or missing!');
        }

        var score = methods._getHint.call(this, score, evt);

        if (this.opt.targetType === 'hint') {
          target = target.html(score);
        } else if (this.opt.targetFormat.indexOf('{score}') !== -1) {
          target = target.html(this.opt.targetFormat.replace('{score}', score));
        } else {
          target = target.val(score);
        }
      }
    },

    _target: function(score, evt) {
      if (this.opt.target) {
        var target = $(this.opt.target);

        if (!target.length) {
          methods._error.call(this, 'Target selector invalid or missing!');
        }

        var hint = methods._getHint.call(this, score, evt);

        if (this.opt.targetType === 'hint') {
          target.html(hint);
        } else if (this.opt.targetFormat.indexOf('{score}') !== -1) {
          target.html(this.opt.targetFormat.replace('{score}', hint));
        } else {
          target.val(score);
        }
      }
    },

    _unbind: function() {
      this.self.off('.raty');
      this.cancel.off('.raty');
      this.stars.off('.raty');
    },

    destroy: function() {
      methods._unbind.call(this);

      this.self.removeData('options').removeData('score').removeClass('raty').empty();
    }
  };

  $.fn.raty = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    } else {
      $.error('Method ' + method + ' does not exist on jQuery.raty');
    }
  };

  $.fn.raty.defaults = {
    cancel: false,
    cancelClass: 'raty-cancel',
    cancelHint: 'Cancel this rating!',
    cancelOff: 'cancel-off.png',
    cancelOn: 'cancel-on.png',
    cancelPlace: 'left',
    click: undefined,
    half: false,
    halfShow: true,
    hints: ['bad', 'poor', 'regular', 'good', 'gorgeous'],
    iconRange: undefined,
    mouseout: undefined,
    mouseover: undefined,
    noRatedMsg: 'Not rated yet!',
    number: 5,
    numberMax: 20,
    path: undefined,
    precision: false,
    readOnly: false,
    round: { down: .25, full: .6, up: .76 },
    score: undefined,
    scoreName: 'score',
    single: false,
    space: true,
    starHalf: 'star-half.png',
    starOff: 'star-off.png',
    starOn: 'star-on.png',
    starType: 'img',
    target: undefined,
    targetFormat: '{score}',
    targetKeep: false,
    targetScore: undefined,
    targetText: '',
    targetType: 'hint',
    width: undefined
  };

})(jQuery);
