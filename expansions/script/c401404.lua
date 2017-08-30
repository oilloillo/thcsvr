--甘兔庵-宇治松千夜
function c401404.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(401404,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c401404.drcon)
	e1:SetTarget(c401404.drtg)
	e1:SetOperation(c401404.drop)
	c:RegisterEffect(e1)

end
function c401404.filter(c)
	return c:IsSetCard(0x404) and c:IsAbleToHand() and not c:IsCode(421404) and not c:IsCode(401404)
end
function c401404.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c401404.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c401404.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c401404.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c401404.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
end
end
