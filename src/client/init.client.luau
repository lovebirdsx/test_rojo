local tests = {
    require(script.test.change_part_color),
}

for _, test in ipairs(tests) do
    test.test()
end
