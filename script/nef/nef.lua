--
Nef = Nef or {}
local os = require("os")
require "expansions/script/nef/cardList"
function Nef.unpack(t, i)
    i = i or 1
    if t[i] then
       return t[i], Nef.unpack(t, i + 1)
    end
end

function Nef.unpackOneMember(t, member, i)
    i = i or 1
    if t[i] and t[i][member] then
       return t[i][member], Nef.unpackOneMember(t, member, i+1)
    end
end

function Nef.AddSynchroProcedureWithDesc(c,f1,f2,ct,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetDescription(desc)
	e1:SetCondition(Auxiliary.SynCondition(f1,f2,ct,99))
	e1:SetTarget(Auxiliary.SynTarget(f1,f2,ct,99))
	e1:SetOperation(Auxiliary.SynOperation(f1,f2,ct,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	return e1
end

function Nef.AddRitualProcEqual(c,filter,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Auxiliary.RPETarget(filter))
	e1:SetOperation(Auxiliary.RPEOperation(filter))
	e1:SetDescription(desc)
	c:RegisterEffect(e1)
	return e1
end

function Nef.AddXyzProcedureWithDesc(c,f,lv,ct,desc,maxct,alterf,op)
	if c.xyz_filter==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if f then
			mt.xyz_filter=function(mc) return f(mc) and mc:IsXyzLevel(c,lv) end
		else
			mt.xyz_filter=function(mc) return mc:IsXyzLevel(c,lv) end
		end
		mt.xyz_count=ct
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetDescription(desc)
	if not maxct then maxct=ct end
	if alterf then
		e1:SetCondition(Auxiliary.XyzCondition2(f,lv,ct,maxct,alterf,desc,op))
		e1:SetTarget(Auxiliary.XyzTarget2(f,lv,ct,maxct,alterf,desc,op))
		e1:SetOperation(Auxiliary.XyzOperation2(f,lv,ct,maxct,alterf,desc,op))
	else
		e1:SetCondition(Auxiliary.XyzCondition(f,lv,ct,maxct))
		e1:SetTarget(Auxiliary.XyzTarget(f,lv,ct,maxct))
		e1:SetOperation(Auxiliary.XyzOperation(f,lv,ct,maxct))
	end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	return e1
end

function Auxiliary.EnablePendulumAttribute(c,reg)
	local argTable = {1}
	return Nef.EnablePendulumAttributeSP(c,99,Auxiliary.TRUE,argTable,reg,nil)
end

function Nef.EnablePendulumAttributeSP(c,num,filter,argTable,reg,tag)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	if c.pend_effect1==nil then
		mt.pend_filter=filter
		mt.pend_arg=argTable
		mt.pend_num=num
		mt.pend_tag=tag
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10000000)
	e1:SetCondition(Nef.PendConditionSP())
	e1:SetOperation(Nef.PendOperationSP())
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(Nef.PendSummonLimitTarget)
	c:RegisterEffect(e2)
	--register by default
	if reg==nil or reg then
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(1160)
		e3:SetType(EFFECT_TYPE_ACTIVATE)
		e3:SetCode(EVENT_FREE_CHAIN)
		c:RegisterEffect(e3)
	end

	mt.pend_effect1 = e1
	mt.pend_effect2 = e2
end

function Nef.PendSummonCheck(c,e,tp,lscale,rscale,filter,argTable,filter2,argTable2,lpc,rpc)
	local code1=lpc:GetOriginalCode()
	local mt1=_G["c" .. code1]

	local code2=rpc:GetOriginalCode()
	local mt2=_G["c" .. code2]

	if mt1.pend_tag or mt2.pend_tag then
		if (mt1.pend_tag == "GodSprite" or mt2.pend_tag == "GodSprite") and c:IsType(TYPE_RITUAL) then
			return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,true,false)
		end
	end

	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
end

function Nef.PConditionFilterSP(c,e,tp,lscale,rscale,filter,argTable,filter2,argTable2,lpz,rpz)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local normalCondition = (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale 
		and Nef.PendSummonCheck(c,e,tp,lscale,rscale,filter,argTable,filter2,argTable2,lpz,rpz) 
	local spCondition = filter(c,Nef.unpack(argTable)) and filter2(c,Nef.unpack(argTable2))
	return spCondition and normalCondition
end

function Nef.PConditionFilterSP2(c,e,tp,lscale,rscale,filter,argTable,filter2,argTable2,lpz,rpz)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local normalCondition = lv>lscale and lv<rscale 
		and Nef.PendSummonCheck(c,e,tp,lscale,rscale,filter,argTable,filter2,argTable2,lpz,rpz)
	local spCondition = filter(c,Nef.unpack(argTable)) and filter2(c,Nef.unpack(argTable2))
	return spCondition and normalCondition
end

function Nef.PendConditionSP()
	return	function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()

				local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
				local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
				if not (lpz and rpz) then return false end
				if c==rpz and _G["c" .. lpz:GetOriginalCode()].pend_filter then return false end

				local temp = (c==lpz and rpz or lpz)
				local n1, filter1, argTable1, tag1, pexfunc1 = Nef.GetPendSPInfo(c)
				local n2, filter2, argTable2, tag2, pexfunc2 = Nef.GetPendSPInfo(temp)

				local lscale=lpz:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end

				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				if ft<=0 then return false end

				if pexfunc1 and pexfunc1(c):IsExists(Nef.PConditionFilterSP2,1,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz) then
					return true
				end
				if pexfunc2 and pexfunc2(temp):IsExists(Nef.PConditionFilterSP2,1,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz) then
					return true
				end

				if og then
					return og:IsExists(Nef.PConditionFilterSP,1,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
				else
					return Duel.IsExistingMatchingCard(Nef.PConditionFilterSP,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
				end
			end
end

function Nef.PendOperationSP()
	return	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
				local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)

				local temp = (c==lpz and rpz or lpz)
				local n1, filter1, argTable1, tag1, pexfunc1 = Nef.GetPendSPInfo(c)
				local n2, filter2, argTable2, tag2, pexfunc2 = Nef.GetPendSPInfo(temp)
				
				local lscale=lpz:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end

				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local pn = (ft>n1 and n1 or ft)
				pn = (pn>n2 and n2 or pn)

				local exg = Group.CreateGroup()
				if pexfunc1 then exg:Merge(pexfunc1(c)) end
				if pexfunc2 then exg:Merge(pexfunc2(temp)) end

				if og then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g1=exg:Filter(Nef.PConditionFilterSP2,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
					local g2=og:Filter(Nef.PConditionFilterSP,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
					g1:Merge(g2)
					local g=Group.Select(g1, tp, 1, pn, nil)
					-- local g=og:FilterSelect(tp,Nef.PConditionFilterSP,1,pn,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
					sg:Merge(g)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g1=exg:Filter(Nef.PConditionFilterSP2,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
					local g2=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_EXTRA,0):Filter(Nef.PConditionFilterSP,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
					g1:Merge(g2)
					local g=Group.Select(g1, tp, 1, pn, nil)
					-- local g=Duel.SelectMatchingCard(tp,Nef.PConditionFilterSP,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,pn,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
					sg:Merge(g)
				end
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(temp))
			end
end

function Nef.SetPendMaxNum(c, num, reset_flag, property, reset_count)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	if mt.pend_effect1==nil then Auxiliary.EnablePendulumAttribute(c) end
	for i = 1,num do 
		c:RegisterFlagEffect(10000000 + c:GetOriginalCode(), reset_flag, property, reset_count)
	end
end

function Nef.SetPendExTarget(c, filter_func)
	-- if not filter_func then filter_func = function(c) return Group.CreateGroup() end
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	if mt.pend_effect1==nil then Auxiliary.EnablePendulumAttribute(c) end
	mt.pend_extra_func=filter_func
end

function Nef.GetPendMaxNum(c)
	return c:GetFlagEffect(10000000 + c:GetOriginalCode())
end

function Nef.GetPendSPInfo(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	if mt.pend_effect1==nil then Auxiliary.EnablePendulumAttribute(c) end

	local pend_num = mt.pend_num and mt.pend_num or 99
	local max_pend_num = Nef.GetPendMaxNum(c)
	if max_pend_num>0 then pend_num = max_pend_num end
	local pend_filter = mt.pend_filter and mt.pend_filter or Auxiliary.TRUE
	local pend_arg = mt.pend_arg and mt.pend_arg or {1}
	local pend_tag = mt.pend_tag
	local pend_extra_func = mt.pend_extra_func

	return pend_num, pend_filter, pend_arg, pend_tag, pend_extra_func
end

function Nef.GetFieldLeftScale(tp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	if lpz then 
		return lpz:GetLeftScale()
	else
		return
	end
end

function Nef.GetFieldRightScale(tp)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if rpz then 
		return rpz:GetRightScale()
	else
		return
	end
end

function Nef.PendSummonLimitTarget(e,c,sump,sumtype,sumpos,targetp)
	local c = nil
	if e then c = e:GetHandler() end
	return c and sumtype==SUMMON_TYPE_PENDULUM and _G["c" .. c:GetOriginalCode()].pend_filter==nil
end

function Nef.EnableDualAttributeSP(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e1)
end

function Nef.EnableDualAttribute(c, flag)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.DualNormalCondition)
	e2:SetValue(TYPE_NORMAL+TYPE_DUAL+TYPE_MONSTER+flag)
	c:RegisterEffect(e2)
end

function Nef.IsDate(Year, Month, Day)
	local year = Year or -1
	local month = Month or -1
	local day = Day or -1
	local date = os.date("*t")
	return (date.year==year or year<0) and (date.month==month or month<0) and (date.day==day or day<0)
end

function Nef.GetDate()
	local date = os.date("*t")
	return date.year, date.month, date.day
end

function Nef.Log(message)
	if AI and AI.Chat ~= nil then AI.Chat(message) end
end

function Nef.LogFormat(fmt, ...)
	Nef.Log(string.format(fmt, ...))
end

function Nef.GetRandomCardCode(num, command)
	local result = {}
	local commandList = {
		[0] = "Main",
		[1] = "Extra"
	}
	local cardType = commandList[command]
	for i=1,num do
		local r = math.random(1,#CardList[cardType])
		result[i] = CardList[cardType][r]
	end
	return result
end