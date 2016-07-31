 
--精灵魔装-炎之鞭
function c40036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c40036.cost)
	e1:SetTarget(c40036.target)
	e1:SetOperation(c40036.operation)
	c:RegisterEffect(e1)
	--Atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c40036.eqlimit)
	c:RegisterEffect(e3)
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40036,0))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(TIMING_BATTLE_PHASE)
	e4:SetCountLimit(1)
	e4:SetTarget(c40036.postg)
	e4:SetOperation(c40036.posop)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40036,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetTarget(c40036.tg)
	e5:SetOperation(c40036.op)
	c:RegisterEffect(e5)
end
function c40036.eqlimit(e,c)
	return c:IsSetCard(0x430) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c40036.refilter(c)
	return c:IsCode(40022) and c:IsAbleToRemoveAsCost()
end
function c40036.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x430) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c40036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40036.refilter,tp,0x16,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c40036.refilter,tp,0x16,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40036.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c40036.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40036.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c40036.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c40036.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c40036.pfilter(c)
	return c:IsPosition(POS_ATTACK) and c:IsType(TYPE_EFFECT)
end
function c40036.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c40036.pfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40036.pfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetCurrentPhase()==PHASE_BATTLE end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,c40036.pfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c40036.posop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsPosition(POS_ATTACK) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c40036.rfilter(c)
	return c:IsSetCard(0x430) and c:IsAbleToHand()
end
function c40036.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c40036.rfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40036.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c40036.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c40036.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsSetCard(0x430) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40036.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(40036,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c40036.spfilter,tp,0x11,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
