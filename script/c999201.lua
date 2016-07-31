--三种神器之　剑
--require "expansions/nef/nef"
function c999201.initial_effect(c)
	--pendulum summon
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,1,aux.TRUE,argTable,false)
	--Dual
	Nef.EnableDualAttribute(c, TYPE_PENDULUM)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c999201.atkcon)
	e2:SetTarget(c999201.atktg)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(999201,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(c999201.descon)
	e4:SetTarget(c999201.destg)
	e4:SetOperation(c999201.desop)
	c:RegisterEffect(e4)
end
function c999201.filter(c)
	return c:IsCode(999204) and not c:IsDisabled()
end
function c999201.atkcon(e)
	local c = e:GetHandler()
	local tp = c:GetControler()
	return c:GetSequence()==6 or c:GetSequence()==7 
		or( c:IsLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(c999201.filter,tp,LOCATION_MZONE,0,1,nil))
end
function c999201.atktg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL)
end
function c999201.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsDualState() and Duel.GetAttackTarget()~=nil
end
function c999201.desfilter(c,tc)
	return c==tc
end
function c999201.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1 = Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
end
function c999201.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		tg:AddCard(e:GetHandler())
		Duel.Destroy(tg,REASON_EFFECT)
	end
end