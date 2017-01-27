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
--Multi from ut of the latest version
function Fus.AddFusionProcFunMulti(c,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local funs={...}
	local mt=_G["c"..c:GetOriginalCode()]
	mt.hana_mat=funs	
	local n=#funs
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Fus.FConditionFunMulti(funs,n,insf))
	e1:SetOperation(Fus.FOperationFunMulti(funs,n,insf))
	c:RegisterEffect(e1)
end
function Fus.FConditionFilterMultiOr(c,funs,n)
	for i=1,n do
		if funs[i](c) then return true end
	end
	return false
end
function Fus.FConditionFilterMulti(c,mg,funs,n,tbt)
	for i=1,n do
		local tp=2^(i-1)
		if bit.band(tbt,tp)~=0 and funs[i](c) then
			local t2=tbt-tp
			if t2==0 then return true end
			local mg2=mg:Clone()
			mg2:RemoveCard(c)
			if mg2:IsExists(Fus.FConditionFilterMulti,1,nil,mg2,funs,n,t2) then return true end
		end
	end
	return false
end
function Fus.CloneTable(g)
	local ng={}
	for i=1,#g do
		local sg=g[i]:Clone()
		table.insert(ng,sg)
	end
	return ng
end
function Fus.FConditionFilterMulti2(c,gr)
	local gr2=Fus.CloneTable(gr)
	for i=1,#gr2 do
		gr2[i]:RemoveCard(c)
	end
	table.remove(gr2,1)
	if #gr2==1 then
		return gr2[1]:IsExists(aux.TRUE,1,nil)
	else
		return gr2[1]:IsExists(Fus.FConditionFilterMulti2,1,nil,gr2)
	end
end
function Fus.FConditionFilterMultiSelect(c,funs,n,mg,sg)
	local valid=Fus.FConditionFilterMultiValid(sg,funs,n)
	if not valid then valid={0} end 
	local all = (2^n)-1
	for k,v in pairs(valid) do
		v=bit.bxor(all,v)
		if Fus.FConditionFilterMulti(c,mg,funs,n,v) then return true end
	end
	return false
end
function Fus.FConditionFilterMultiValid(g,funs,n)
	local tp={}
	local tc=g:GetFirst()
	while tc do
		local tp1={}
		for i=1,n do
			if funs[i](tc) then table.insert(tp1,2^(i-1)) end
		end
		table.insert(tp,tp1)
		tc=g:GetNext()
	end
	return Fus.FConditionMultiGenerateValids(tp,n)
end
function Fus.FConditionMultiGenerateValids(vs,n)
	local c=2
	while #vs > 1 do
		local v1=vs[1]
		table.remove(vs,1)
		local v2=vs[1]
		table.remove(vs,1)
		table.insert(vs,1,Fus.FConditionMultiCombine(v1,v2,n,c))
		c=c+1
	end
	return vs[1]
end
function Fus.FConditionMultiCombine(t1,t2,n,c)
	local res={}
	for k1,v1 in pairs(t1) do
		for k2,v2 in pairs(t2) do
			table.insert(res,bit.bor(v1,v2))
		end
	end 
	res=Fus.FConditionMultiCheckCount(res,n)
	return Fus.FConditionFilterMultiClean(res)
end
function Fus.FConditionMultiCheckCount(vals,n)
	local res={} local flags={}
	for k,v in pairs(vals) do
		local c=0
		for i=1,n do
			if bit.band(v,2^(i-1))~=0 then c=c+1 end
		end
		if not flags[c] then
			res[c] = {v}
			flags[c] = true
		else
			table.insert(res[c],v)
		end
	end
	local mk=0
	for k,v in pairs(flags) do
		if k>mk then mk=k end
	end
	return res[mk]
end
function Fus.FConditionFilterMultiClean(vals)
	local res={} local flags={}
	for k,v in pairs(vals) do
		if not flags[v] then
			table.insert(res,v)
			flags[v] = true
		end
	end
	return res
end
function Fus.FConditionFunMulti(funs,n,insf)
	return function(e,g,gc,chkfnf)
		local c=e:GetHandler()
		if g==nil then return insf end
		if c:IsFaceup() then return false end
		local chkf=bit.band(chkfnf,0xff)
		local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,c):Filter(Fus.FConditionFilterMultiOr,nil,funs,n)
		if gc then
			if not gc:IsCanBeFusionMaterial(c) then return false end
			local check_tot=(2^n)-1
			local mg2=mg:Clone()
			mg2:RemoveCard(gc)
			for i=1,n do
				if funs[i](gc) then
					local tbt=check_tot-2^(i-1)
					if mg2:IsExists(Fus.FConditionFilterMulti,1,nil,mg2,funs,n,tbt) then return true end
				end
			end
			return false
		end
		local fs=false
		local groups={}
		for i=1,n do
			table.insert(groups,Group.CreateGroup())
		end
		local tc=mg:GetFirst()
		while tc do
			for i=1,n do
				if funs[i](tc) then
					groups[i]:AddCard(tc)
					if aux.FConditionCheckF(tc,chkf) then fs=true end
				end
			end
			tc=mg:GetNext()
		end
		local gr2=Fus.CloneTable(groups)
		if chkf~=PLAYER_NONE then
			return fs and gr2[1]:IsExists(Fus.FConditionFilterMulti2,1,nil,gr2)
		else
			return gr2[1]:IsExists(Fus.FConditionFilterMulti2,1,nil,gr2)
		end
	end
end
function Fus.FOperationFunMulti(funs,n,insf)
	return function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
		local c=e:GetHandler()
		local chkf=bit.band(chkfnf,0xff)
		local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,c):Filter(Fus.FConditionFilterMultiOr,nil,funs,n)
		if gc then
			local sg=Group.FromCards(gc)
			local mg=g:Clone()
			mg:RemoveCard(gc)
			for i=1,n-1 do
				local mg2=mg:Filter(Fus.FConditionFilterMultiSelect,nil,funs,n,mg,sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg2=mg2:Select(tp,1,1,nil)
				sg:AddCard(sg2:GetFirst())
				mg:RemoveCard(sg2:GetFirst())
			end
			Duel.SetFusionMaterial(sg)
			return
		end
		local sg=Group.CreateGroup()
		local mg=g:Clone()
		for i=1,n do
			local mg2=mg:Filter(Fus.FConditionFilterMultiSelect,nil,funs,n,mg,sg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg2=nil
			if i==1 and chkf~=PLAYER_NONE then
				sg2=mg2:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
			else
				sg2=mg2:Select(tp,1,1,nil)
			end
			sg:AddCard(sg2:GetFirst())
			mg:RemoveCard(sg2:GetFirst())
		end
		Duel.SetFusionMaterial(sg)
	end
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
function Fus.CheckMaterialSingle(c,fc)
	if not c:IsCanBeFusionMaterial(fc) then return false end
	local t=fc.hana_mat
	if not t then return false end
	for i,f in pairs(t) do
		if f(c) then return true end
	end
	return false
end