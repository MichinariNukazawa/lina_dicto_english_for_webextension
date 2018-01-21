
all: copy

.PHONY: all clean
.PHONY: copy package

copy:
	make clean
	# English版の外部ファイル統合済みjsファイルを生成
	#// make -C ../lina_dicto_english/
	cp -r ../lina_dicto_english/ .
	bash ../lina_dicto_for_android/tool/loader.sh lina_dicto_english/lina_dicto/lina_dicto/js/dictionary_loader.js
	bash ../lina_dicto_for_android/tool/loader.sh lina_dicto_english/lina_dicto/lina_dicto/js/language.js
	# webextension を持ってきて、辞書ファイル等を置き換え
	#// make -C ../lina_dicto_for_webextension/
	cp -r ../lina_dicto_for_webextension .
	cp lina_dicto_english/lina_dicto/lina_dicto/js/dictionary_loader.js \
		lina_dicto_for_webextension/lina_dicto/js/
	# manifest.json
	sed -i -e 's/Esperanto/English/' lina_dicto_for_webextension/manifest.json
	sed -i -e 's/"name".*,/"name": "lina_dicto_english for webextension",/' \
		lina_dicto_for_webextension/manifest.json
	sed -i -e 's/"default_title".*,/"default_title": "lina_dicto_english for webextension",/' \
		lina_dicto_for_webextension/manifest.json
	#
	cp -r overwrite/* lina_dicto_for_webextension/
	# icon
	convert lina_dicto_english/overwrite/image/icon.png -resize 48 \
		lina_dicto_for_webextension/icon/icon_48.png
	convert lina_dicto_english/overwrite/image/icon.png -resize 96 \
		lina_dicto_for_webextension/icon/icon_96.png
	convert lina_dicto_english/overwrite/image/icon.png -resize 128 \
		lina_dicto_for_webextension/icon/icon_128.png
	#// convert lina_dicto_for_webextension/icon/icon_48.png -monochrome \
	#// 	lina_dicto_for_webextension/icon/disable_icon_48.png

package:
	make clean
	make copy
	cd lina_dicto_for_webextension/ && bash ./package.sh "lina_dicto_english_for_webextension"

clean:
	rm -rf lina_dicto_english/
	rm -rf lina_dicto_for_webextension/

