 
--Maniacal Princess
function c13040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND)
	e1:SetTarget(c13040.target)
	e1:SetOperation(c13040.activate)
	c:RegisterEffect(e1)
	--sol
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c13040.thtg)
	e2:SetOperation(c13040.thop)
	c:RegisterEffect(e2)
end
function c13040.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c13040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and 
		Duel.IsExistingMatchingCard(c13040.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
end
function c13040.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c13040.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,c13040.filter,tp,0,LOCATION_HAND,1,2,nil)
		if sg:GetCount()>0 then
			Duel.SSet(1-tp,sg)
		else
			local sg=Duel.GetMatchingGroup(c13040.cfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
			Duel.Destroy(sg,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-p)
	end
end
function c13040.tgfilter(c)
	return c:IsCode(13006) and c:IsAbleToHand()
end
function c13040.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c13040.tgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c13040.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c13040.tgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
