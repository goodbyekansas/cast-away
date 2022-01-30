MAIN_SRCS := src/main.cpp
MAIN_OBJS := $(patsubst %.cpp,%.o,$(MAIN_SRCS))

LOADER_SRCS := src/loader.cpp src/ship.cpp src/base.cpp
LOADER_OBJS := $(patsubst %.cpp,%.o,$(LOADER_SRCS))

SLOOP_SRCS := src/sloop.cpp
SLOOP_OBJS := $(patsubst %.cpp,%.o,$(SLOOP_SRCS))

.PHONY: all run clean

all: libshiploader.so sloop.so cast-away

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -I ./src/ -DSTDLIB="\"$(STDLIB)\"" -c $< -o $@

libshiploader.so: $(LOADER_OBJS)
	$(CXX) $(LDFLAGS) $(LOADER_OBJS) -o libshiploader.so -shared

cast-away: $(MAIN_OBJS) libshiploader.so
	$(CXX) $(LDFLAGS) $(MAIN_OBJS) -L ./ -lshiploader -ldl -o cast-away

sloop.so: $(SLOOP_OBJS) libshiploader.so
	$(CXX) $(LDFLAGS) $(SLOOP_OBJS) -o sloop.so -L ./ -lshiploader -shared

clean:
	rm -f ./cast-away ./sloop.so ./libloader.so $(SLOOP_OBJS) $(MAIN_OBJS) $(LOADER_OBJS)

# This target is used outside nix
run:
	nix build -f ./default.nix libstd
	@echo "Running with GNU libstdc++ (built with Clang):"
	@echo ""
	@./result/bin/cast-away ./result/lib/sloop.so 2>&1 | sed "s/^/  🐄 [libstdc++] /"
	@echo ""

	nix build -f ./default.nix libcxx
	@echo "Running with LLVM libc++ (built with Clang):"
	@echo ""
	@./result/bin/cast-away ./result/lib/sloop.so 2>&1 | sed "s/^/  🐉 [libc++] /"
	@echo ""

	nix build -f ./default.nix libcxxStrcmp
	@echo "Running with LLVM libc++ (built with Clang, using strcmp fallback through _LIBCXXABI_FORGIVING_DYNAMIC_CAST):"
	@echo ""
	@./result/bin/cast-away ./result/lib/sloop.so 2>&1 | sed "s/^/  🐉 [libc++ (strcmp)] /"
	@echo ""
