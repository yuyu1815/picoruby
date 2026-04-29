def ai_probe_now_us
  Machine.uptime_us
rescue
  Machine.board_millis * 1000
end

def ai_probe_emit(key, value)
  puts "AI_PROBE #{key}=#{value}"
end

ai_probe_emit("marker", "begin")
ai_probe_emit("uptime_us", ai_probe_now_us)
ai_probe_emit("stack_usage", Machine.stack_usage || -1)
ai_probe_emit("task_stack_free", Machine.task_stack_free) if Machine.respond_to?(:task_stack_free)
ai_probe_emit("memory_before", Machine.memory_snapshot) if Machine.respond_to?(:memory_snapshot)
ai_probe_emit("cpu_before", Machine.cpu_snapshot) if Machine.respond_to?(:cpu_snapshot)

n = 1000
t = ai_probe_now_us
i = 0
while i < n
  i += 1
end
dt = ai_probe_now_us - t
ai_probe_emit("empty_loop_iterations", n)
ai_probe_emit("empty_loop_us_total", dt)
ai_probe_emit("empty_loop_us_per_iter_x1000", dt * 1000 / n)

t = ai_probe_now_us
i = 0
x = 0
while i < n
  x += i
  i += 1
end
dt = ai_probe_now_us - t
ai_probe_emit("integer_add_iterations", n)
ai_probe_emit("integer_add_us_total", dt)
ai_probe_emit("integer_add_us_per_iter_x1000", dt * 1000 / n)

def ai_probe_method(x)
  x + 1
end

t = ai_probe_now_us
i = 0
x = 0
while i < n
  x = ai_probe_method(x)
  i += 1
end
dt = ai_probe_now_us - t
ai_probe_emit("method_call_iterations", n)
ai_probe_emit("method_call_us_total", dt)
ai_probe_emit("method_call_us_per_iter_x1000", dt * 1000 / n)

n = 200
t = ai_probe_now_us
i = 0
while i < n
  s = "probe-" + i.to_s
  i += 1
end
dt = ai_probe_now_us - t
ai_probe_emit("small_string_alloc_iterations", n)
ai_probe_emit("small_string_alloc_us_total", dt)
ai_probe_emit("small_string_alloc_us_per_iter_x1000", dt * 1000 / n)

t = ai_probe_now_us
i = 0
while i < n
  a = [i, i + 1, i + 2]
  i += 1
end
dt = ai_probe_now_us - t
ai_probe_emit("small_array_alloc_iterations", n)
ai_probe_emit("small_array_alloc_us_total", dt)
ai_probe_emit("small_array_alloc_us_per_iter_x1000", dt * 1000 / n)

t = ai_probe_now_us
GC.start
ai_probe_emit("gc_start_us", ai_probe_now_us - t)

ai_probe_emit("memory_after", Machine.memory_snapshot) if Machine.respond_to?(:memory_snapshot)
ai_probe_emit("cpu_after", Machine.cpu_snapshot) if Machine.respond_to?(:cpu_snapshot)
ai_probe_emit("marker", "end")
