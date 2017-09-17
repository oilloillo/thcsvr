--花与妖的连结✿风见幽香
function c25501.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c25501.lkcon)
	e1:SetOperation(c25501.lkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c25501.atkval)
	c:RegisterEffect(e2)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c25501.atklimit)
	c:RegisterEffect(e4)
	--immune trap
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetCondition(c25501.econ)
	e6:SetValue(c25501.efilter)
	c:RegisterEffect(e6)
end
function c25501.lkfilter(c, lc, tp)
	local flag = c:IsFaceup() and c:IsCanBeLinkMaterial(lc)
	if c:IsControler(tp) then
		return flag
	else
		return flag and not c:IsType(TYPE_LINK)
	end
end
-- 每个素材对应的素材值
function c25501.val(c)
	return 1
end
-- 首个素材必须满足的要求
function c25501.matfilter(c, mg, tp)
	if Duel.GetLocationCountFromEx(tp, tp, c) < 1 then return end
	local target_val = 7 -- 目标素材值
	local minc = 7		 -- 最小所需个数
	local maxc = 99		 -- 最大所需个数
	local val = c25501.val(c)
	if val == 99 then return false end
	local g = mg:Clone()
	g:RemoveCard(c)
	-- 卧槽CheckWithSumGreater不能指定最小所需个数
	-- return g:CheckWithSumGreater(func, target_val-val, minc, maxc)
	return g:GetCount() >= minc - 1
end
function c25501.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c25501.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
	return mg:IsExists(c25501.matfilter, 1, nil, mg, tp)
end
function c25501.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg = Duel.GetMatchingGroup(c25501.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
	local func = c25501.val
	local fmat = mg:FilterSelect(tp, c25501.matfilter, 1, 1, nil, mg, func, tp):GetFirst()
	if not fmat then return end
	local val = func(fmat)
	if val == 99 then return end
	mg:RemoveCard(fmat)
	local target_val = 7 -- 目标素材值
	local minc = 7		 -- 最小所需个数
	local maxc = 99		 -- 最大所需个数
	-- 卧槽SelectWithSumGreater不能指定最小所需个数
	-- local mat = mg:SelectWithSumGreater(c:GetControler(), func, target_val-val, minc, maxc)
	local mat = mg:Select(tp, minc, maxc, nil)
	mat:AddCard(fmat)
	if mat:GetCount() > 0 then
		c:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_MATERIAL+REASON_LINK)
	end
end
function c25501.atkval(e,c)
	return c:GetLinkedGroupCount()*1000
end
function c25501.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c25501.econ(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetLP(tp) > Duel.GetLP(1-tp)
end
function c25501.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
