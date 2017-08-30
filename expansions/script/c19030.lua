--噬魂的噩梦体✿哆来咪&幽香
function c19030.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x273),aux.FilterBoolFunction(Card.IsFusionSetCard,0x3208),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--277174517
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	e3:SetCondition(c19030.condition)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19030,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	--e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCondition(c19030.condition)
	e4:SetTarget(c19030.destg)
	e4:SetOperation(c19030.desop)
	c:RegisterEffect(e4)
end
c19030.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0x273),
aux.FilterBoolFunction(Card.IsFusionSetCard,0x3208),
}
function c19030.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c19030.desfilter(c)
	return c:IsDestructable()
end
function c19030.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c19030.desfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c19030.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c19030.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c19030.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
