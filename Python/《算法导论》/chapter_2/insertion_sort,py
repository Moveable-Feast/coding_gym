def insertion_sort(A):
    for j in range(1, len(A)):
        key = A[j]
        # Insert A[j] into the sorted sequence A[1..j-1]
        i = j - 1
        while i >= 0 and A[i] > key:
            A[i + 1] = A[i]
            i -= 1
        A[i + 1] = key
    return A

arr = [6, 5, 2, 4, 1, 3]
sorted_arr = insertion_sort(arr)
print(sorted_arr)  # Output: [1, 2, 3, 4, 5, 6]