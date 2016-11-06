--module for fusion material func
--script by Nanahira
Fus=Fus or {}
local table=require("table")
function Fus.CodeFilter(code)
	return function(c)
		return c:IsFusionCode(code)
	end
end
function Fus.AddFusionProcCode2(c,code1,code2,sub,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={Fus.CodeFilter(code1),Fus.CodeFilter(code2)}
	Auxiliary.AddFusionProcCode2(c,code1,code2,sub,insf)
end
function Fus.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={Fus.CodeFilter(code1),Fus.CodeFilter(code2),Fus.CodeFilter(code3)}
	Auxiliary.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
end
function Fus.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={Fus.CodeFilter(code1),Fus.CodeFilter(code2),Fus.CodeFilter(code3),Fus.CodeFilter(code4)}
	Auxiliary.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
end
function Fus.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={Fus.CodeFilter(code1),f}
	Auxiliary.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
end
function Fus.AddFusionProcFun2(c,f1,f2,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={f1,f2}
	Auxiliary.AddFusionProcFun2(c,f1,f2,insf)
end
function Fus.AddFusionProcCodeRep(c,code1,cc,sub,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={}
	for i=1,cc do
		table.insert(mt.hana_mat,Fus.CodeFilter(code1))
	end
	Auxiliary.AddFusionProcCodeRep(c,code1,cc,sub,insf)
end
function Fus.AddFusionProcFunRep(c,f,cc,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={}
	for i=1,cc do
		table.insert(mt.hana_mat,f)
	end
	Auxiliary.AddFusionProcFunRep(c,f,cc,insf)
end
function Fus.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={f1}
	for i=1,maxc do
		table.insert(mt.hana_mat,f2)
	end
	Auxiliary.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
end
function Fus.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={Fus.CodeFilter(code1)}
	for i=1,maxc do
		table.insert(mt.hana_mat,f)
	end
	Auxiliary.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
end