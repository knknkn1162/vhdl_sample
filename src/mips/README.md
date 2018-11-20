# Milestone

## pipeline with 2 instrs

### non-hazard case

```asm
add $t0, $s0, $s1
add $t1, $s1, $s2
```

```asm
addi $t0, $s0, 5
add $s1, $s0, $s0
```

### forwarding

```asm
add $s1, $s0, $s0
add $s2, $s1, $s1
```

```asm
addi $s0, $0, 5
add $s1, $s0, $s0
```

```asm
sw $s0, 12($0)
lw $s1, 12($0)
```

```asm
; assume that $s0 /= [8]
lw $s0, 8($0)
sw $s0, 12($0)
```

### stall

```asm
lw $s0, 12($0)
add $s1, $s0, $s0
```


```asm
lw $s0, 12($0)
addi $s1, $s0, 5
```

### prefetch
