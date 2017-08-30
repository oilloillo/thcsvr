 
--天丸「壶中的天地」
function c21128.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21128.cost)
	e1:SetTarget(c21128.target)
	e1:SetOperation(c21128.activate)
	c:RegisterEffect(e1)
end
function c21128.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and Duel.GetFlagEffect(tp,21128)==0 end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,21128,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c21128.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<6 then return false end
		local g=Duel.GetDecktopGroup(tp,6)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c21128.sfilter(c)
	return c:IsSetCard(0x208) and c:IsLevelAbove(3)
end
function c21128.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,6)
	local g=Duel.GetDecktopGroup(p,6)
	if g:GetCount()>0 then
		if g:IsExists(c21128.sfilter,1,nil) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(p,c21128.sfilter,1,1,nil)
			if sg:GetFirst():IsAbleToHand() then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-p,sg)
				Duel.ShuffleHand(p)
			else
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		Duel.ShuffleDeck(p)
		end
	end
end
