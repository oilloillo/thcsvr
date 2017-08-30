--雾符『毒气花园』
function c25049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetOperation(c25049.activate)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25049,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetTarget(c25049.tokentg)
	e2:SetOperation(c25049.tokenop)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c25049.val)
	c:RegisterEffect(e3)
end
function c25049.tfilter(c)
	return c:IsSetCard(0x165) and c:IsAbleToHand()
end
function c25049.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c25049.tfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(25049,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c25049.tokentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep~=tp and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and bit.band(r,REASON_BATTLE)==0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,25014,0,0x208,400,600,1,RACE_PLANT,ATTRIBUTE_WIND) and e:GetHandler():GetFlagEffect(25049)<4 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	e:GetHandler():RegisterFlagEffect(25049,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c25049.tokenop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,25014,0,0x208,400,600,1,RACE_PLANT,ATTRIBUTE_WIND) then
		local token=Duel.CreateToken(tp,25014)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c25049.val(e)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,0x164)*-300
end