--地狱『炼狱气息』
local M = c999713
local Mid = 999713
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, 9997131+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1, 9997132+EFFECT_COUNT_CODE_DUEL)
	e2:SetLabelObject(e1)
	e2:SetTarget(M.target2)
	e2:SetOperation(M.activate)
	c:RegisterEffect(e2)
end

function M.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetSequence() < 5
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(M.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,c) end
	local sg=Duel.GetMatchingGroup(M.filter,tp,LOCATION_SZONE,LOCATION_SZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end

function M.filter2(c, tp)
	return c:IsControler(tp) and c:IsFacedown()
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(M.filter,tp,LOCATION_SZONE,LOCATION_SZONE,e:GetHandler())
	local num1 = sg:FilterCount(M.filter2, c, tp)
	local num2 = sg:FilterCount(M.filter2, c, 1-tp)
	if Duel.SendtoGrave(sg, REASON_EFFECT)>0 then
		if num1 > 0 then Duel.Damage(1-tp, 800*num1, REASON_EFFECT) end
		if num2 > 0 then Duel.Damage(tp, 800*num2, REASON_EFFECT) end
	end
end

function M.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local e1=e:GetLabelObject()
	if chk==0 then return Duel.IsExistingMatchingCard(M.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,c) 
		and Nef.skList and Nef.skList.isSummon[tp] == true and not e1:IsActivatable(tp) end
	local sg=Duel.GetMatchingGroup(M.filter,tp,LOCATION_SZONE,LOCATION_SZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end