disp('Entered factorization');
model = struct;

T=patches;
model.variables.a = randn(size(T,1), R);
model.variables.b = randn(size(T,2), R);
model.variables.c = randn(size(T,3), R);
model.factors.A = 'a';
model.factors.B = 'b';
model.factors.C = 'c';
model.factorizations.tensor.data = T;
model.factorizations.tensor.cpd  = {'A', 'B', 'C'};
model.factorizations.reg.regL1 = {'B','A','C'};
model.factors.A = {'a', @struct_nonneg};
model.factors.B = {'b', @struct_nonneg};
model.factors.C = {'c', @struct_nonneg};
sdf_check(model,'print');
sol = sdf_nls(model);

Uhat=sol.factors;
filters=Uhat.A;
patchFactors=Uhat.B;
neighbors=Uhat.C;