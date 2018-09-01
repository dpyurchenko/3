import std.array, std.typecons;

alias Tuple!(ulong, size_t, size_t) Step; // Sum, index of first branch array, index of second branch array. Sum type must be large enough to handle sum of all "profits" without overflow.
																					// Actually if you see "ulong smth..." in code here, this "smth" must be large enough. If it's not - use BigInt. But BigInt dramatically increases memory usage.

size_t[] solve(uint[][] branches)
{
	Step[][] steps = uninitializedArray!(Step[][])(branches.length, branches[0].length);

	for(ptrdiff_t i = 0; i < branches[0].length; ++i)
	{
		steps[0][i][0] = branches[0][i];
		steps[0][i][1] = i;
		steps[0][i][2] = i;
	}

	for(ptrdiff_t i = 1; i < branches.length; ++i)
	{
		steps[i][0][0] = 0;
		steps[i][0][1] = 0;
		steps[i][0][2] = 0;
	}

	for(ptrdiff_t i = 0; i < branches.length - 1; ++i)  // Most important part of algorithm where we are calculating max(profit(br0[0], br1[m]), profit(br0[1], br1[m-1]), profit(br0[2], br1[m-2]), ..., profit(br0[m], br1[0])) etc.
		for(ptrdiff_t j = 0; j < branches[0].length; ++j)
			steps[i + 1][j] = max(j, steps[i], branches[i + 1]);

	ulong max = 0;																			// We are looking for max here, because of sometimes we can have very unoptimal benefits, so we can save some resources.
	ptrdiff_t index = 0;
	for(ptrdiff_t i = 0; i < branches[0].length; ++i)
		if(steps[branches.length - 1][i][0] > max)
		{
			max = steps[branches.length - 1][i][0];
			index = i;
		}

	auto answer = uninitializedArray!(size_t[])(branches.length); // Reading recommendations and filling the answer vector.
	ptrdiff_t k = answer.length - 1;
	for(ptrdiff_t i = answer.length - 1; i > -1; --i)
	{
		answer[i] = steps[k][index][2];
		index = steps[k--][index][1];
	}

	return answer;
}

Step max(ptrdiff_t rAmount, Step[] steps, uint[] branch)
{
	Step step;
	ulong max = 0;
	for(ptrdiff_t i = 0; i <= rAmount; ++i)
	{
		auto tmp = steps[i][0] + branch[rAmount - i];
		if(tmp >= max)											 // I'm using ">=" here instead of ">", because of we can have multiple solutions, but some of them less desirable than others.
		{																		 // Assume we have two solutions with equal maximum profit e.g. [0, 1, 2] and [1, 1, 1]. [1, 1, 1] is better because of with [0, 1, 2] we must close the first branch.
			max = tmp;												 // Soulitons with [x, 0, 0, ..., x] appears at the beginning, but [x, x, x, ..., 0] appears at the end, so ">=" gives [x, x, x, ...] solutions better chance to appear in full solution.
			step[0] = tmp;										 // But actually we must check all available solutions, to choose the best. To do this we must run solve() with all possible permutations of branches and ">" instead of ">=".
			step[1] = cast(uint)i;						 // However this raises complexity of our algorithm to O(n!(nm^2-nm)), where n - number of branches, m - resource amount.
			step[2] = cast(uint)(rAmount - i); // If we want to know any of best solutions, then complexity is about O(nm^2-nm), if I'm done all calcs right.
		}																		 // Memory complexity is O(nm) for "simple" case and O(n!nm) for all solutions.
	}																			 // But if we don't need to handle all solutions in memory simultaneously then memory complexity reverts back to O(nm).
	return step;
}
