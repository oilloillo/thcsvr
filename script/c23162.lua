--两栖类的神明✿洩矢诹访子
function c23162.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x497),aux.FilterBoolFunction(c23162.fusfilter),true)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c23162.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENCE)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c23162.atkup)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(23162,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c23162.condition)
	e5:SetTarget(c23162.target)
	e5:SetOperation(c23162.operation)
	c:RegisterEffect(e5)
end
c23162.material_setcode=0x497
function c23162.fusfilter(c)
	return c:GetCounter(0x28a)>0
end
function c23162.val(e,c)
	return Duel.GetCounter(0,LOCATION_ONFIELD,LOCATION_ONFIELD,0x28a)*300
end
function c23162.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c23162.atkup(e,c)
	return Duel.GetMatchingGroupCount(c23162.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*500
end
function c23162.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c23162.filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToDeck()
end
function c23162.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c23162.filter,tp,LOCATION_GRAVE,0,2,nil) end
end
function c23162.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c23162.filter,tp,LOCATION_GRAVE,0,2,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c23162.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(23162,5))
	local se1=Duel.SelectOption(tp,aux.Stringid(23162,1),aux.Stringid(23162,2))+1
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(23162,6))
	local se2=Duel.SelectOption(tp,aux.Stringid(23162,3),aux.Stringid(23162,4))+1
	local code=0
	local fp=0
	if se1==1 then
		code=23178
	else
		code=23179
	end
	if se2==1 then
		fp=tp
	else
		fp=1-tp
	end
	local field=Duel.CreateToken(tp,code)
	Duel.MoveToField(field,tp,fp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.RaiseEvent(field,EVENT_CHAIN_SOLVED,field:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
