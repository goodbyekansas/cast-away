MAIN_SRCS := src/main.cpp src/base.cpp src/ship.cpp
MAIN_OBJS := $(patsubst %.cpp,%.o,$(MAIN_SRCS))

SLOOP_SRCS := src/sloop.cpp src/base.cpp src/ship.cpp
SLOOP_OBJS := $(patsubst %.cpp,%.o,$(SLOOP_SRCS))

.PHONY: all run clean

all: sloop.so cast-away

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -I ./src/ -DSTDLIB="\"$(STDLIB)\"" -c $< -o $@

cast-away: $(MAIN_OBJS)
	$(CXX) $(LDFLAGS) $(MAIN_OBJS) -ldl -o cast-away

sloop.so: $(SLOOP_OBJS)
	$(CXX) $(LDFLAGS) $(SLOOP_OBJS) -o sloop.so -shared

clean:
	rm -f ./cast-away ./sloop.so $(SLOOP_OBJS) $(MAIN_OBJS)

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
	@echo "Running with LLVM libc++ (built with Clang, using strcmp fallback through _LIBCXX_DYNAMIC_FALLBACK):"
	@echo ""
	@./result/bin/cast-away ./result/lib/sloop.so 2>&1 | sed "s/^/  🐉 [libc++ (strcmp)] /"
	@echo ""
