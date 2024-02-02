echo "::group::Building main book"
mdbook build -d book
echo "::endgroup::"
for po_lang in $(cat ./LANGUAGES); do
    echo "::group::Building $po_lang translation"
    MDBOOK_BOOK__LANGUAGE=$po_lang \
    mdbook build -d book/$po_lang
    echo "::endgroup::"
done