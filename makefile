LIBRARY_NAME = shittp

CXX = g++

CXXFLAGS = -Wfatal-errors -Werror \
-Wall -Wextra -Wpedantic \
-Wfloat-equal -Wsign-conversion -Wfloat-conversion \
-Wno-error=unused-but-set-parameter \
-Wno-error=unused-but-set-variable \
-Wno-error=unused-function \
-Wno-error=unused-label \
-Wno-error=unused-local-typedefs \
-Wno-error=unused-parameter \
-Wno-error=unused-result \
-Wno-error=unused-variable \
-Wno-error=unused-value \
-ggdb -Og

sources := $(wildcard src/*.cpp)
source_names := $(sources:src/%.cpp=%)

bin/lib$(LIBRARY_NAME).a: $(source_names:%=obj/%.o) | bin
	ar rcs $@ $^

bin:
	mkdir -p $@

obj/%.o: src/%.cpp | obj
	$(CXX) $(CXXFLAGS) -c $< -o $@

obj:
	mkdir -p $@

ifneq ($(MAKECMDGOALS),clean)
include $(source_names:%=dep/%.d)
endif

dep/%.d: src/%.cpp | dep
	$(CXX) $(CXXFLAGS) $< -MM -MT $(<:src/%.cpp=obj/%.o) -MP -MF $@

dep:
	mkdir -p $@

.PHONY: clean debug

clean:
	rm -rf bin dep obj
