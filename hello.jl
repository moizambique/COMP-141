# Insertion Sort function
function insertion_sort!(arr)
    for i in 2:length(arr)
        key = arr[i]
        j = i - 1
        while j >= 1 && arr[j] > key
            arr[j + 1] = arr[j]
            j -= 1
        end
        arr[j + 1] = key
    end
end

# Example usage
numbers = [64, 34, 25, 12, 22, 11, 90]
println("Original: ", numbers)
insertion_sort!(numbers)
println("Sorted: ", numbers)
