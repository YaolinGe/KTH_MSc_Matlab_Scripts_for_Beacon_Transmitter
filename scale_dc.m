function V = scale_dc(v, val)
V = abs(v*max(absC(val))/max(abs(v)));
end