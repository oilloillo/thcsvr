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
	aux.AddFusionProcCode2(c,code1,code2,sub,insf)
end
function Fus.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={Fus.CodeFilter(code1),Fus.CodeFilter(code2),Fus.CodeFilter(code3)}
	aux.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
end
function Fus.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={Fus.CodeFilter(code1),Fus.CodeFilter(code2),Fus.CodeFilter(code3),Fus.CodeFilter(code4)}
	aux.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
end
function Fus.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={Fus.CodeFilter(code1),f}
	aux.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
end
function Fus.AddFusionProcFun2(c,f1,f2,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={f1,f2}
	aux.AddFusionProcFun2(c,f1,f2,insf)
end
function Fus.AddFusionProcCodeRep(c,code1,cc,sub,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={}
	for i=1,cc do
		table.insert(mt.hana_mat,Fus.CodeFilter(code1))
	end
	aux.AddFusionProcCodeRep(c,code1,cc,sub,insf)
end
function Fus.AddFusionProcFunRep(c,f,cc,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={}
	for i=1,cc do
		table.insert(mt.hana_mat,f)
	end
	aux.AddFusionProcFunRep(c,f,cc,insf)
end
function Fus.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={f1}
	for i=1,maxc do
		table.insert(mt.hana_mat,f2)
	end
	aux.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
end
function Fus.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat={Fus.CodeFilter(code1)}
	for i=1,maxc do
		table.insert(mt.hana_mat,f)
	end
	aux.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
end
function Fus.AddFusionProcFunMulti(c,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local funs={...}
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat=funs	
	local n=#funs
	aux.AddFusionProcMix(c,true,insf,...)
end
function Fus.NonImmuneFilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function Fus.FusionMaterialFilter(c,oppo)
	if oppo and c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER)
end
function Fus.GetFusionMaterial(tp,loc,oloc,f,gc,e,...)
	local g1=Duel.GetFusionMaterial(tp)
	if loc then
		local floc=bit.band(loc,LOCATION_ONFIELD+LOCATION_HAND)
		if floc~=0 then
			g1=g1:Filter(Card.IsLocation,nil,floc)
		else
			g1:Clear()
		end
		local eloc=loc-floc
		if eloc~=0 then
			local g2=Duel.GetMatchingGroup(Fus.FusionMaterialFilter,tp,eloc,0,nil)
			g1:Merge(g2)
		end
	end
	if oloc and oloc~=0 then
		local g3=Duel.GetMatchingGroup(Fus.FusionMaterialFilter,tp,0,oloc,nil,true)
		g1:Merge(g3)
	end
	if f then g1=g1:Filter(f,nil,...) end
	if gc then g1:RemoveCard(gc) end
	if e then g1=g1:Filter(Fus.NonImmuneFilter,nil,e) end
	return g1
end
function Fus.CheckMaterialSingle(c,fc,mc)
	local tp=fc:GetControler()
	if not c:IsCanBeFusionMaterial(fc) or Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc),fc)<=0 then return false end
	local t=fc.hana_mat
	if not t then return false end
	for i,f in pairs(t) do
		if f(c) then return true end
	end
	return false
end