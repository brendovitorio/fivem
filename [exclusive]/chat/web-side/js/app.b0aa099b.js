(function () {
  "use strict";
  var e = {
      4428: function (e, s, t) {
        var a = t(9963),
          i = t(6252),
          c = t(3577),
          n = t.p + "img/bin.ac618532.svg",
          h = t.p + "img/emoji.ace7f71d.svg",
          o = t.p + "img/send.5e1a9767.svg";
        const l = (e) => (
            (0, i.dD)("data-v-f64c8bea"), (e = e()), (0, i.Cn)(), e
          ),
          r = { id: "app" },
          d = { id: "chat-area" },
          g = { class: "message-sendedBy" },
          m = ["onClick"],
          u = l(() => (0, i._)("img", { src: n }, null, -1)),
          p = [u],
          y = { key: 1, id: "input-area" },
          f = { class: "input-box" },
          C = { class: "commandPrompt" },
          T = ["src"],
          w = { key: 2, class: "filter-types-area" },
          k = ["onClick"],
          v = { class: "emoji-area" },
          b = ["onClick"];
        function j(e, s, n, l, u, j) {
          return (
            (0, i.wg)(),
            (0, i.iD)("div", r, [
              (0, i._)("div", d, [
                u.chatOpened
                  ? ((0, i.wg)(),
                    (0, i.iD)(
                      "div",
                      {
                        key: 0,
                        class: "messages-area",
                        id: "scroll",
                        style: (0, c.j5)({
                          "overflow-y": u.showInput ? "auto" : "hidden",
                        }),
                        ref: "messagesRef",
                      },
                      [
                        ((0, i.wg)(!0),
                        (0, i.iD)(
                          i.HY,
                          null,
                          (0, i.Ko)(
                            j.filteredMessages,
                            (e, s) => (
                              (0, i.wg)(),
                              (0, i.iD)("div", { class: "message", key: s }, [
                                (0, i._)(
                                  "span",
                                  {
                                    class: (0, c.C_)([
                                      "message-type",
                                      {
                                        chamado: "chamado" === e.type,
                                        advertencia: "advertencia" === e.type,
                                        Admin: "Admin" === e.type,
                                        ajuda: "ajuda" === e.type,
                                        megaphone: "megaphone" === e.type,
                                        Police: "Police" === e.type,
                                        Radar: "Radar" === e.type,
                                        Multa: "Multa" === e.type,
                                        Paramedic: "Paramedic" === e.type,
                                        Mechanic: "Mechanic" === e.type,
                                        Compras: "Compras" === e.type,
                                        ffa: "ffa" === e.type,
                                        Painel: "Painel" === e.type,
                                      },
                                    ]),
                                    style: (0, c.j5)(e.custom && e.custom),
                                  },
                                  (0, c.zw)(e.type),
                                  7
                                ),
                                (0, i._)(
                                  "div",
                                  {
                                    class: (0, c.C_)([
                                      "message-content",
                                      {
                                        chamado: "chamado" === e.type,
                                        advertencia: "advertencia" === e.type,
                                        Admin: "Admin" === e.type,
                                        ajuda: "ajuda" === e.type,
                                        megaphone: "megaphone" === e.type,
                                        Police: "Police" === e.type,
                                        Radar: "Radar" === e.type,
                                        Multa: "Multa" === e.type,
                                        Paramedic: "Paramedic" === e.type,
                                        Mechanic: "Mechanic" === e.type,
                                        Compras: "Compras" === e.type,
                                        ffa: "ffa" === e.type,
                                        Painel: "Painel" === e.type,
                                      },
                                    ]),
                                    style: (0, c.j5)(e.custom && e.custom),
                                  },
                                  [
                                    (0, i._)(
                                      "span",
                                      g,
                                      (0, c.zw)(e.author) !== "false" && (0, c.zw)(e.author) + ":",
                                      1
                                    ),
                                    (0, i.Uk)(
                                      " " + (0, c.zw)(e.content) + " ",
                                      1
                                    ),
                                    (0, i.wy)(
                                      (0, i._)(
                                        "button",
                                        {
                                          class: "delete",
                                          onClick: () =>
                                            j.deleteMessage(e.content),
                                        },
                                        p,
                                        8,
                                        m
                                      ),
                                      [[a.F8, u.isAdmin]]
                                    ),
                                  ],
                                  6
                                ),
                              ])
                            )
                          ),
                          128
                        )),
                      ],
                      4
                    ))
                  : (0, i.kq)("", !0),
                u.showInput
                  ? ((0, i.wg)(),
                    (0, i.iD)("div", y, [
                      (0, i._)("div", f, [
                        (0, i._)("div", C, [
                          (0, i.wy)(
                            (0, i._)(
                              "input",
                              {
                                type: "text",
                                maxlength: "250",
                                spellcheck: "false",
                                class: "input",
                                "onUpdate:modelValue":
                                  s[0] || (s[0] = (e) => (u.message = e)),
                                autofocus: "",
                                onKeypress:
                                  s[1] ||
                                  (s[1] = (0, a.D2)(
                                    (0, a.iM)(
                                      (...e) => j.send && j.send(...e),
                                      ["prevent"]
                                    ),
                                    ["enter"]
                                  )),
                                ref: "input",
                                placeholder: "Digite sua mensagem aqui...",
                              },
                              null,
                              544
                            ),
                            [[a.nr, u.message]]
                          ),
                        ]),
                        (0, i._)(
                          "img",
                          {
                            src: h,
                            style: (0, c.j5)({
                              opacity: u.emojiPickerOpened ? "1" : ".5",
                            }),
                            onClick:
                              s[2] ||
                              (s[2] = (e) =>
                                (u.emojiPickerOpened = !u.emojiPickerOpened)),
                            class: "emoji",
                          },
                          null,
                          4
                        ),
                        (0, i._)("img", {
                          src: o,
                          onClick:
                            s[3] || (s[3] = (...e) => j.send && j.send(...e)),
                          class: "send",
                        }),
                      ]),
                      (0, i._)(
                        "div",
                        {
                          class: "notify-box",
                          onClick:
                            s[4] ||
                            (s[4] = (...e) =>
                              j.changeNotify && j.changeNotify(...e)),
                        },
                        [
                          (0, i._)(
                            "img",
                            {
                              style: (0, c.j5)({
                                width: u.notifyToggled ? "0.833vw" : "1.146vw",
                              }),
                              src: u.notifyToggled ? t(7422) : t(3632),
                            },
                            null,
                            12,
                            T
                          ),
                        ]
                      ),
                    ]))
                  : (0, i.kq)("", !0),
                u.showInput
                  ? ((0, i.wg)(),
                    (0, i.iD)("div", w, [
                      (0, i._)(
                        "button",
                        {
                          class: (0, c.C_)([
                            "chatTypeBackground",
                            { selected: "all" === u.selectedChatType },
                          ]),
                          onClick:
                            s[5] || (s[5] = () => j.changeChatType("all")),
                        },
                        " Todos ",
                        2
                      ),
                      (0, i._)(
                        "button",
                        {
                          class: (0, c.C_)([
                            "chatTypeBackground",
                            { selected: "global" === u.selectedChatType },
                          ]),
                          onClick:
                            s[6] || (s[6] = () => j.changeChatType("global")),
                        },
                        " Global ",
                        2
                      ),
                      (0, i._)(
                        "button",
                        {
                          class: (0, c.C_)([
                            "chatTypeBackground",
                            { selected: "ajuda" === u.selectedChatType },
                          ]),
                          onClick:
                            s[7] || (s[7] = () => j.changeChatType("ajuda")),
                        },
                        " Ajuda ",
                        2
                      ),
                      (0, i._)(
                        "button",
                        {
                          class: (0, c.C_)([
                            "chatTypeBackground",
                            { selected: "local" === u.selectedChatType },
                          ]),
                          onClick:
                            s[8] || (s[8] = () => j.changeChatType("local")),
                        },
                        " Local ",
                        2
                      ),
                      ((0, i.wg)(!0),
                      (0, i.iD)(
                        i.HY,
                        null,
                        (0, i.Ko)(
                          u.chatTypes,
                          (e, s) => (
                            (0, i.wg)(),
                            (0, i.iD)(
                              "button",
                              {
                                class: (0, c.C_)([
                                  "chatTypeBackground",
                                  { selected: u.selectedChatType === e },
                                ]),
                                key: s,
                                onClick: () => j.changeChatType(e),
                              },
                              (0, c.zw)(e),
                              11,
                              k
                            )
                          )
                        ),
                        128
                      )),
                      (0, i.wy)(
                        (0, i._)(
                          "div",
                          v,
                          [
                            ((0, i.wg)(!0),
                            (0, i.iD)(
                              i.HY,
                              null,
                              (0, i.Ko)(
                                u.emojiList,
                                (e, s) => (
                                  (0, i.wg)(),
                                  (0, i.iD)(
                                    "div",
                                    {
                                      class: "emoji-item",
                                      onClick: () => j.selectEmoji(e),
                                      key: s,
                                    },
                                    (0, c.zw)(e),
                                    9,
                                    b
                                  )
                                )
                              ),
                              128
                            )),
                          ],
                          512
                        ),
                        [[a.F8, u.emojiPickerOpened]]
                      ),
                    ]))
                  : (0, i.kq)("", !0),
              ]),
            ])
          );
        }
        t(7658), t(4633);
        var M = JSON.parse(
            '{"1":"😀 😃 😄 😁 😆 😅 😂 🤣 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨 🧐 🤓 😎 🤩 🥳 😏 😒 😞 😔 😟 😕 🙁 ☹️ 😣 😖 😫 😩 🥺 😢 😭 😮‍💨 😤 😠 😡 🤬 🤯 😳 🥵 🥶 😱 😨 😰 😥 😓 🤗 🤔 🤭 🤫 🤥 😶 😶 😐 😑 😬 🙄 😯 😦 😧 😮 😲 🥱 😴 🤤 😪 😵 😵‍💫 🤐 🥴 🤢 🤮 🤧 😷 🤒 🤕 🤑 🤠 😈 👿 👹 👺 🤡 💩 👻 💀 ☠️ 👽 👾 🤖 🎃 😺 😸 😹 😻 😼 😽 🙀 😿 😾 👋 🤚 🖐 ✋ 🖖 👌 🤏 ✌️ 🤞 🤟 🤘 🤙 👈 👉 👆 🖕 👇 ☝️ 👍 👎 ✊ 👊 🤛 🤜 👏 🙌 👐 🤲 🤝 🙏 ✍️ 💅 🤳 💪 🦾 🦵 🦿 🦶 👣 👂 🦻 👃 🧠 🦷 🦴 👀 👁 👅 👄 💋 🩸 🍏 🍎 🍐 🍊 🍋 🍌 🍉 🍇 🍓 🫐 🍈 🍒 🍑 🥭 🍍 🥥 🥝 🍅 🍆 🥑 🥦 🥬 🥒 🌶 🫑 🌽 🥕 🫒 🧄 🧅 🥔 🍠 🫘 🥐 🥯 🍞 🥖 🥨 🧀 🥚 🍳 🧈 🥞 🧇 🥓 🥩 🍗 🍖 🦴 🌭 🍔 🍟 🍕 🫓 🥪 🥙 🧆 🌮 🌯 🫔 🥗 🥘 🫕 🥫 🍝 🍜 🍲 🍛 🍣 🍱 🥟 🦪 🍤 🍙 🍚 🍘 🍥 🥠 🥮 🍢 🍡 🍧 🍨 🍦 🥧 🧁 🍰 🎂 🍮 🍭 🍬 🍫 🍿 🍩 🍪 🌰 🥜 🍯 🥛 🍼 ☕️ 🍵 🧃 🥤 🍶 🍺 🍻 🥂 🍷 🥃 🍸 🍹 🧉 🍾 🧊 🥄 🍴 🍽 🥣 🥡 🥢 🧂 🚓 🚑 🚒 🚐"}'
          ),
          _ = async (e, s, t) => {
            const a = {
                method: "POST",
                headers: { "Content-type": "application/json; charset=UTF-8" },
                body: JSON.stringify(s || {}),
              },
              i = window.GetParentResourceName
                ? window.GetParentResourceName()
                : "chat",
              c = await fetch(`https://${i}/${e}`, a);
            return await c.json();
          },
          O = {
            data() {
              return {
                emojiPickerOpened: !1,
                emojiList: M[1].split(" "),
                blockedMessages: [],
                chatOpened: !1,
                showInput: !1,
                chatTypes: [],
                isAdmin: !1,
                selectedChatType: "all",
                listener: null,
                input: null,
                notifyToggled: !0,
                message: "",
                messages: [],
                messagesRef: null,
                cachedMessages: [],
                currCachedMsg: 1,
              };
            },
            watch: {
              messages: {
                handler() {
                  this.showChatTimer && clearTimeout(this.showChatTimer),
                    this.notifyToggled &&
                      ((this.chatOpened = !0),
                      setTimeout(() => {
                        this.$nextTick(() => {
                          const e = this.$refs.messagesRef;
                          e.scrollTop = e.scrollHeight;
                        });
                      }, 125)),
                    this.resetShowChatTimer();
                },
                deep: !0,
              },
            },
            computed: {
              filteredMessages() {
                return "all" !== this.selectedChatType
                  ? this.messages.filter(
                      (e) =>
                        e.type === this.selectedChatType ||
                        "megaphone" === e.type
                    )
                  : this.messages;
              },
            },
            methods: {
              deleteMessage(e) {
                _("ChatDelete", { message: e });
              },
              changeChatType(e) {
                this.selectedChatType = e;
                const s = this.$refs.messagesRef;
                this.$nextTick(() => {
                  s.scrollTop = s.scrollHeight;
                });
              },
              isCommand() {
                return "/" === this.message[0];
              },
              isCommandPreview() {
                return this.message.includes("!staff")
                  ? "Admin"
                  : this.message.includes("!gr")
                  ? this.chatTypes[1]
                  : "all" == this.selectedChatType
                  ? "local"
                  : this.selectedChatType;
              },
              changeNotify() {
                this.notifyToggled = !this.notifyToggled;
              },
              checkBlockedMessages() {
                let e = !1;
                return (
                  this.message.split(" ").map((s) => {
                    this.blockedMessages.forEach((s) => {
                      this.message.includes(s) && (e = !0);
                    });
                  }),
                  !e
                );
              },
              checkFlood() {
                if (this.isCommand() || this.isAdmin) return !0;
                let e = !1;
                return (
                  this.cachedMessages.map((s) => {
                    s !== this.message || (e = !0);
                  }),
                  !e
                );
              },
              send() {
                "" !== this.message
                  ? this.checkBlockedMessages() &&
                    this.checkFlood() &&
                    (this.cachedMessages.length > 5 &&
                      this.cachedMessages.shift(),
                    this.cachedMessages.push(this.message),
                    this.message.includes("!staff") &&
                      ((this.message = this.message.replace("!staff", "")),
                      (this.selectedChatType = "Admin"),
                      setImmediate(() => {
                        this.selectedChatType = "all";
                      })),
                    (this.message.includes("!global") ||
                      this.message.includes("!gl")) &&
                      ((this.message = this.message.replace("!global", "")),
                      (this.message = this.message.replace("!gl", "")),
                      (this.selectedChatType = "global"),
                      setImmediate(() => {
                        this.selectedChatType = "global";
                      })),
                    (this.message.includes("!ajuda") ||
                      this.message.includes("!aj")) &&
                      ((this.message = this.message.replace("!ajuda", "")),
                      (this.message = this.message.replace("!aj", "")),
                      (this.selectedChatType = "ajuda"),
                      setImmediate(() => {
                        this.selectedChatType = "ajuda";
                      })),
                    this.message.includes("!gr") &&
                      ((this.message = this.message.replace("!gr", "")),
                      (this.selectedChatType = this.chatTypes[1]),
                      setImmediate(() => {
                        this.selectedChatType = "all";
                      })),
                    _("ChatSubmit", {
                      message: this.message,
                      tag: this.isCommandPreview(),
                    }),
                    (this.message = ""),
                    this.hideInput())
                  : this.hideInput();
              },
              keyUp() {
                this.currCachedMsg > 5 ||
                  this.currCachedMsg > this.cachedMessages.length ||
                  ((this.message =
                    this.cachedMessages[
                      this.cachedMessages.length - this.currCachedMsg
                    ]),
                  this.currCachedMsg++);
              },
              keyDown() {
                this.currCachedMsg <= 1 ||
                  (this.currCachedMsg--,
                  (this.message =
                    this.cachedMessages[
                      this.cachedMessages.length - this.currCachedMsg
                    ]));
              },
              clear() {
                this.messages = [];
              },
              selectEmoji(e) {
                (this.message += e), (this.emojiPickerOpened = !1);
              },
              clearShowChatTimer() {
                clearTimeout(this.showChatTimer);
              },
              resetShowChatTimer() {
                this.clearShowChatTimer(),
                  (this.showChatTimer = setTimeout(() => {
                    this.showInput || (this.chatOpened = !1);
                  }, 7e3));
              },
              hideInput() {
                (this.message = ""),
                  (this.showInput = !1),
                  this.resetShowChatTimer(),
                  _("close");
              },
            },
            destroyed() {
              clearInterval(this.focusTimer),
                window.removeEventListener("message", this.listener);
            },
            mounted() {
              fetch("http://chat/getCityName").then((e) => {
                const s = document.querySelector(".selected");
                s &&
                  (s.style.background = "candy" === e ? "#00F8B9" : "#c38a10");
              }),
                (this.listener = window.addEventListener("message", (e) => {
                  const s = e.data || e.detail;
                  switch (s.Action) {
                    case "Chat":
                      (this.chatOpened = !0),
                        (this.showInput = !0),
                        (this.currCachedMsg = 1),
                        (this.chatTypes = s.Data),
                        (this.blockedMessages = s.Block),
                        (this.isAdmin = this.chatTypes.includes("Admin")),
                        setTimeout(() => {
                          this.$nextTick(() => {
                            this.$refs.input.focus(),
                              (this.$refs.messagesRef.scrollTop =
                                this.$refs.messagesRef.scrollHeight);
                          });
                        }, 125);
                      break;
                    case "Message":
                      this.messages.push({
                        type: s.Type,
                        author: s.Author,
                        content: s.Message,
                        custom: s.Custom,
                      });
                      break;
                    case "Delete":
                      this.messages = this.messages.filter(
                        (e) => e.content !== s.Message
                      );
                      break;
                    default:
                      break;
                  }
                })),
                window.addEventListener("keydown", (e) => {
                  "Escape" == e.code
                    ? this.hideInput()
                    : "ArrowUp" == e.code
                    ? this.keyUp()
                    : "ArrowDown" == e.code && this.keyDown();
                });
            },
          },
          D = t(3744);
        const I = (0, D.Z)(O, [
          ["render", j],
          ["__scopeId", "data-v-f64c8bea"],
        ]);
        var A = I;
        (0, a.ri)(A).mount("#app");
      },
      3632: function (e, s, t) {
        e.exports = t.p + "img/notify_off.3f06f721.svg";
      },
      7422: function (e, s, t) {
        e.exports = t.p + "img/notify_on.8efb3693.svg";
      },
    },
    s = {};
  function t(a) {
    var i = s[a];
    if (void 0 !== i) return i.exports;
    var c = (s[a] = { exports: {} });
    return e[a](c, c.exports, t), c.exports;
  }
  (t.m = e),
    (function () {
      var e = [];
      t.O = function (s, a, i, c) {
        if (!a) {
          var n = 1 / 0;
          for (r = 0; r < e.length; r++) {
            (a = e[r][0]), (i = e[r][1]), (c = e[r][2]);
            for (var h = !0, o = 0; o < a.length; o++)
              (!1 & c || n >= c) &&
              Object.keys(t.O).every(function (e) {
                return t.O[e](a[o]);
              })
                ? a.splice(o--, 1)
                : ((h = !1), c < n && (n = c));
            if (h) {
              e.splice(r--, 1);
              var l = i();
              void 0 !== l && (s = l);
            }
          }
          return s;
        }
        c = c || 0;
        for (var r = e.length; r > 0 && e[r - 1][2] > c; r--) e[r] = e[r - 1];
        e[r] = [a, i, c];
      };
    })(),
    (function () {
      t.d = function (e, s) {
        for (var a in s)
          t.o(s, a) &&
            !t.o(e, a) &&
            Object.defineProperty(e, a, { enumerable: !0, get: s[a] });
      };
    })(),
    (function () {
      t.g = (function () {
        if ("object" === typeof globalThis) return globalThis;
        try {
          return this || new Function("return this")();
        } catch (e) {
          if ("object" === typeof window) return window;
        }
      })();
    })(),
    (function () {
      t.o = function (e, s) {
        return Object.prototype.hasOwnProperty.call(e, s);
      };
    })(),
    (function () {
      t.p = "";
    })(),
    (function () {
      var e = { 143: 0 };
      t.O.j = function (s) {
        return 0 === e[s];
      };
      var s = function (s, a) {
          var i,
            c,
            n = a[0],
            h = a[1],
            o = a[2],
            l = 0;
          if (
            n.some(function (s) {
              return 0 !== e[s];
            })
          ) {
            for (i in h) t.o(h, i) && (t.m[i] = h[i]);
            if (o) var r = o(t);
          }
          for (s && s(a); l < n.length; l++)
            (c = n[l]), t.o(e, c) && e[c] && e[c][0](), (e[c] = 0);
          return t.O(r);
        },
        a = (self["webpackChunkbox"] = self["webpackChunkbox"] || []);
      a.forEach(s.bind(null, 0)), (a.push = s.bind(null, a.push.bind(a)));
    })();
  var a = t.O(void 0, [998], function () {
    return t(4428);
  });
  a = t.O(a);
})();
//# sourceMappingURL=app.b0aa099b.js.map
