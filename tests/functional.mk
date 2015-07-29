$(call setup-stamp-file,FTST_FUNCTIONAL_TESTS_STAMP,/functional-tests)

FTST_DIR := $(BUILDDIR)/tmp/functional-tests
FTST_TEST_TMP := $(FTST_DIR)/test-tmp
FTST_IMAGE_DIR := $(FTST_DIR)/image
FTST_IMAGE_ROOTFSDIR := $(FTST_IMAGE_DIR)/rootfs
FTST_IMAGE := $(FTST_DIR)/rkt-inspect.aci
FTST_IMAGE_MANIFEST_SRC := $(MK_SRCDIR)/image/manifest
FTST_IMAGE_MANIFEST := $(FTST_IMAGE_DIR)/manifest
FTST_IMAGE_TEST_DIRS := $(FTST_IMAGE_ROOTFSDIR)/dir1 $(FTST_IMAGE_ROOTFSDIR)/dir2
FTST_INSPECT_BINARY := $(FTST_DIR)/inspect
FTST_ACI_INSPECT := $(FTST_IMAGE_ROOTFSDIR)/inspect
FTST_ECHO_SERVER_BINARY := $(FTST_DIR)/echo-socket-activated
FTST_ACI_ECHO_SERVER := $(FTST_IMAGE_ROOTFSDIR)/echo-socket-activated
FTST_EMPTY_IMAGE_DIR := $(FTST_DIR)/empty-image
FTST_EMPTY_IMAGE_ROOTFSDIR := $(FTST_EMPTY_IMAGE_DIR)/rootfs
FTST_EMPTY_IMAGE := $(FTST_DIR)/rkt-empty.aci
FTST_EMPTY_IMAGE_MANIFEST_SRC := $(MK_SRCDIR)/empty-image/manifest
FTST_EMPTY_IMAGE_MANIFEST := $(FTST_EMPTY_IMAGE_DIR)/manifest

TOPLEVEL_CHECK_STAMPS += $(FTST_FUNCTIONAL_TESTS_STAMP)
INSTALL_FILES += $(FTST_IMAGE_MANIFEST_SRC):$(FTST_IMAGE_MANIFEST):- $(FTST_INSPECT_BINARY):$(FTST_ACI_INSPECT):- $(FTST_EMPTY_IMAGE_MANIFEST_SRC):$(FTST_EMPTY_IMAGE_MANIFEST):- $(FTST_ECHO_SERVER_BINARY):$(FTST_ACI_ECHO_SERVER):-
CREATE_DIRS += $(FTST_DIR) $(FTST_IMAGE_DIR) $(FTST_IMAGE_ROOTFSDIR) $(FTST_EMPTY_IMAGE_DIR) $(FTST_EMPTY_IMAGE_ROOTFSDIR) $(FTST_IMAGE_TEST_DIRS) $(FTST_TEST_TMP)
CLEAN_FILES += $(FTST_IMAGE)

$(FTST_FUNCTIONAL_TESTS_STAMP): RKT := $(RKT_BINARY)
$(FTST_FUNCTIONAL_TESTS_STAMP): ACTOOL := $(ACTOOL)
$(FTST_FUNCTIONAL_TESTS_STAMP): FTST_IMAGE := $(FTST_IMAGE)
$(FTST_FUNCTIONAL_TESTS_STAMP): FTST_EMPTY_IMAGE := $(FTST_EMPTY_IMAGE)
$(FTST_FUNCTIONAL_TESTS_STAMP): FTST_TEST_TMP := $(FTST_TEST_TMP)
$(FTST_FUNCTIONAL_TESTS_STAMP): ABS_GO := $(ABS_GO)
$(FTST_FUNCTIONAL_TESTS_STAMP): GO_ENV := $(GO_ENV)
$(FTST_FUNCTIONAL_TESTS_STAMP): GO := $(GO)
$(FTST_FUNCTIONAL_TESTS_STAMP): FTST_INSPECT_BINARY := $(FTST_INSPECT_BINARY)
# GO_TEST_FUNC_ARGS deliberately not copied into rule
$(FTST_FUNCTIONAL_TESTS_STAMP): REPO_PATH := $(REPO_PATH)
$(FTST_FUNCTIONAL_TESTS_STAMP): $(FTST_IMAGE) $(FTST_EMPTY_IMAGE) $(ACTOOL_STAMP) $(RKT_STAMP) | $(FTST_TEST_TMP)
	sudo RKT="$(RKT)" ACTOOL="$(ACTOOL)" RKT_INSPECT_IMAGE="$(FTST_IMAGE)" RKT_EMPTY_IMAGE="$(FTST_EMPTY_IMAGE)" FUNCTIONAL_TMP="$(FTST_TEST_TMP)" GO="$(ABS_GO)" INSPECT_BINARY="$(FTST_INSPECT_BINARY)" $(GO_ENV) "$(GO)" test -timeout 20m -v $(GO_TEST_FUNC_ARGS) $(REPO_PATH)/tests

$(FTST_IMAGE): ACTOOL := $(ACTOOL)
$(FTST_IMAGE): FTST_IMAGE_DIR := $(FTST_IMAGE_DIR)
$(FTST_IMAGE): FTST_IMAGE_ROOTFSDIR := $(FTST_IMAGE_ROOTFSDIR)
$(FTST_IMAGE): $(FTST_IMAGE_MANIFEST) $(FTST_ACI_INSPECT) $(FTST_ACI_ECHO_SERVER) | $(FTST_IMAGE_TEST_DIRS)
	echo -n dir1 >$(FTST_IMAGE_ROOTFSDIR)/dir1/file
	echo -n dir2 >$(FTST_IMAGE_ROOTFSDIR)/dir2/file
	"$(ACTOOL)" build --overwrite "$(FTST_IMAGE_DIR)" "$@"

BGB_BINARY := $(FTST_INSPECT_BINARY)
BGB_PKG_IN_REPO := $(subst $(MK_TOPLEVEL_SRCDIR)/,,$(MK_SRCDIR))/inspect
BGB_GO_FLAGS := -a -installsuffix cgo
BGB_ADDITIONAL_GO_ENV := CGO_ENABLED=0

include makelib/build_go_bin.mk

$(FTST_EMPTY_IMAGE): ACTOOL := $(ACTOOL)
$(FTST_EMPTY_IMAGE): FTST_EMPTY_IMAGE_DIR := $(FTST_EMPTY_IMAGE_DIR)
$(FTST_EMPTY_IMAGE): $(FTST_EMPTY_IMAGE_MANIFEST) | $(FTST_EMPTY_IMAGE_ROOTFSDIR)
	"$(ACTOOL)" build --overwrite "$(FTST_EMPTY_IMAGE_DIR)" "$@"

BGB_BINARY := $(FTST_ECHO_SERVER_BINARY)
BGB_PKG_IN_REPO := $(subst $(MK_TOPLEVEL_SRCDIR)/,,$(MK_SRCDIR))/echo-socket-activated
BGB_GO_FLAGS := -a -installsuffix cgo
BGB_ADDITIONAL_GO_ENV := CGO_ENABLED=0

include makelib/build_go_bin.mk

FTST_FUNCTIONAL_TESTS_STAMP :=

FTST_DIR :=
FTST_IMAGE_DIR :=
FTST_IMAGE_ROOTFSDIR :=
FTST_IMAGE :=
FTST_IMAGE_MANIFEST_SRC :=
FTST_IMAGE_MANIFEST :=
FTST_IMAGE_TEST_DIRS :=
FTST_INSPECT_BINARY :=
FTST_ACI_INSPECT :=
FTST_ECHO_SERVER_BINARY :=
FTST_ACI_ECHO_SERVER :=
FTST_EMPTY_IMAGE_DIR :=
FTST_EMPTY_IMAGE_ROOTFSDIR :=
FTST_EMPTY_IMAGE :=
FTST_EMPTY_IMAGE_MANIFEST_SRC :=
FTST_EMPTY_IMAGE_MANIFEST :=