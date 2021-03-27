data = idq_importHistogram('TagsHistogram_619.txt');


data = idq_combinefiles
data = idq_rebin(data,5e-9,0)
plot(data.time,data.counts)