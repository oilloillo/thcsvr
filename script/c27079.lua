--星辰降落的神灵✿丰聪耳神子
--require "expansions/nef/nef"
function c27079.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	--TODO: CDB: 灵摆1: 这个效果不会被无效化
	local argTable = {TYPE_RITUAL,0x208}
	Nef.EnablePendulumAttributeSP(c,5,c27079.pendFilter,argTable,false,"GodSprite")
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27079,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c27079.cost)
	e2:SetTarget(c27079.target)
	e2:SetOperation(c27079.operation)
	c:RegisterEffect(e2)
	--level down
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27079,1))
	e3:SetCategory(CATEGORY_LVCHANGE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c27079.stg)
	e3:SetOperation(c27079.sop)
	c:RegisterEffect(e3)
end
function c27079.pendFilter(c, ctype, setname)
	return c:IsType(ctype) and c:IsSetCard(setname)
end
function c27079.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.PayLPCost(tp,1000)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c27079.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x912) and not c:IsCode(27079) and c:IsAbleToRemove()
end
function c27079.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27079.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c27079.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c27079.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c27079.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()>1 end
end
function c27079.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,567)
	local lv=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(-lv)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(-lv*100)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
