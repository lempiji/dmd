/*
REQUIRED_ARGS: -verrors=spec -o-
PERMUTE_ARGS:
TEST_OUTPUT:
---
(spec:1) fail_compilation/fail20730b.d-mixin-44(44): Error: C style cast illegal, use `cast(int)mod`
fail_compilation/fail20730b.d(27): Error: template `fail20730b.atomicOp` cannot deduce function from argument types `!("+=")(shared(uint), int)`, candidates are:
fail_compilation/fail20730b.d(42):        `atomicOp(string op, T, V1)(ref shared T val, V1 mod)`
  with `op = "+=",
       T = uint,
       V1 = int`
  must satisfy the following constraint:
`       __traits(compiles, mixin("(int)mod"))`
---
*/
void test20730()
{
    auto f = File().byLine;
}

struct File
{
    shared uint refs;

    this(this)
    {
        atomicOp!"+="(refs, 1);
    }

    struct ByLineImpl(Char)
    {
        File file;
        char[] line;
    }

    auto byLine()
    {
        return ByLineImpl!char();
    }
}

T atomicOp(string op, T, V1)(ref shared T val, V1 mod)
    // C-style cast causes raises a parser error whilst gagged.
    if (__traits(compiles, mixin("(int)mod")))
{
    return val;
}
