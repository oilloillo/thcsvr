--不羁奔放的古豪✿伊吹萃香
local M = c999709
local Mid = 999709
function M.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsType,TYPE_XYZ),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Mid,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(M.target)
	e1:SetOperation(M.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(M.destg)
	e3:SetValue(M.value)
	e3:SetOperation(M.desop)
	c:RegisterEffect(e3)
	--disable effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(M.disop)
	c:RegisterEffect(e4)
end

function M.cfilter(c, atk)
	return c:IsFaceup() and c:IsSetCard(0xaa5) and c:GetAttack()<atk
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetCount()>0 end
	if eg:GetCount()<1 then return false end
	local _, atk = Group.GetMaxGroup(eg, Card.GetAttack)
	local g = Duel.GetMatchingGroup(M.cfilter, tp, LOCATION_MZONE, 0, nil, atk)
	return g:GetCount()>0
end

function M.operation(e,tp,eg,ep,ev,re,r,rp)
	local _, atk = Group.GetMaxGroup(eg, Card.GetAttack)
	local g = Duel.GetMatchingGroup(M.cfilter, tp, LOCATION_MZONE, 0, nil, atk)
	local tc = g:GetFirst()
	while tc do 
		--atkup
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		tc = g:GetNext()
	end
end

function M.dfilter(c, tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0xaa5) and c:GetAttack()>=500
end

function M.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(M.dfilter, nil, tp)
		return count>0
	end
	if Duel.SelectYesNo(tp,aux.Stringid(Mid, 1)) then
		local sg = eg:FilterSelect(tp, M.dfilter, 1, 100, nil, tp)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	end
	return false
end

function M.value(e,c)
	return c:IsFaceup() and c:GetLocation()==LOCATION_MZONE and c:IsSetCard(0xaa5)
end

function M.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg = e:GetLabelObject()
	local tc = sg:GetFirst()
	while tc do
		--atkdown
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-500)
		tc:RegisterEffect(e1)
		tc = sg:GetNext()
	end
	sg:DeleteGroup()
end

function M.disfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xaa5)
end

function M.disop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if rp==ec:GetControler() then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()==0 then return end
	local sg = g:Filter(M.disfilter, nil, tp)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_CARD,0,Mid)
	if Duel.NegateEffect(ev) then
		Duel.Destroy(sg, REASON_EFFECT)
	end
end
