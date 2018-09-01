import std.stdio, rd;

/*immutable uint[] m = [0,  5, 10, 15, 20, 25]; // Михайловка
immutable uint[] u = [0, 20, 23, 28, 35, 39]; // Урюпинск
immutable uint[] k = [0, 15, 29, 31, 39, 45]; // Котельниково*/

immutable uint[] m = [0, 322, 357,  412,  400,  485]; // Михайловка
immutable uint[] u = [0, 333, 487,  526,  734,  949]; // Урюпинск
immutable uint[] k = [0, 427, 764, 1025, 1593, 1612]; // Котельниково

/*immutable uint[] m = [0, 50, 100, 150, 200, 250]; // Михайловка
immutable uint[] u = [0, 40,  65,  80,  90, 150]; // Урюпинск
immutable uint[] k = [0, 60,  80, 100, 120, 130]; // Котельниково*/

/*immutable uint[] m = [0, 60, 130, 170, 220, 240]; // Михайловка
immutable uint[] u = [0, 70, 100, 140, 200, 260]; // Урюпинск
immutable uint[] k = [0, 60, 130, 180, 210, 220]; // Котельниково*/

/*immutable uint[] m = [0, 12, 23, 30, 40, 50]; // Михайловка
immutable uint[] u = [0, 12, 21, 30, 40, 50]; // Урюпинск
immutable uint[] k = [0, 12, 22, 30, 40, 50]; // Котельниково*/

/*immutable uint[] m = [0, 12, 12, 12, 12, 12]; // Михайловка
immutable uint[] u = [0, 12, 12, 12, 12, 12]; // Урюпинск
immutable uint[] k = [0, 12, 12, 12, 12, 12]; // Котельниково*/

uint[][] branches = [m, u, k]; // Must contain at least 2 arrays. All arrays must be the same length. Length of any of arrays - 1 is a maximum resource amount. So here length is 6, resource amount 5.
															 // All arrays must contain at least one zero. All arrays must be sorted in ascending order.

void main()
{
	/*import std.array, std.algorithm, std.random;										// WARNING!!! Eats about 350 Mb of memory on x64 and lots of CPU.
	uint[][] branches = uninitializedArray!(uint[][])(1000, 12346); // 1000 branches, 12345 resources. Note, what second parameter is 12345 + 1.

	for(ptrdiff_t i = 0; i < branches.length; ++i)
	{
		branches[i][0] = 0;
		for(ptrdiff_t j = 1; j < branches[i].length; ++j)
			branches[i][j] = uniform(1, 1001);
		sort(branches[i]);
	}*/

	//writeln(branches);

	auto answer = solve(branches);

	uint sum = 0;
	ptrdiff_t i = 0;
	foreach(ans; answer)
		sum += branches[i++][ans];

	writeln(answer, "\nmax. profit - ", sum);

	sum = 0;
	foreach(ans; answer)
		sum += ans;
	writeln(sum); // Note, what sometimes sum of allocated resources can be less than available amount of resources.
}
