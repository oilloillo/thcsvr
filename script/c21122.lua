 
--藤原「灭罪寺院伤」
function c21122.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x11e0)
	e1:SetTarget(c21122.target)
	e1:SetOperation(c21122.activate)
	c:RegisterEffect(e1)
end
function c21122.filter(c)
	return c:IsDestructable()
end
function c21122.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mc=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_HAND,0,nil,0x161)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c21122.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21122.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) and mc>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21122.filter,tp,0,LOCATION_ONFIELD,1,mc,e:GetHandler())
	e:SetLabel(g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*200)
end
function c21122.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ct=e:GetLabel()
	if tg:GetCount()>0 and Duel.Destroy(tg,REASON_EFFECT)~=0 then
		if Duel.Damage(1-tp,ct*200,REASON_EFFECT) then
			local dis=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,ct,ct,nil,0x161)
			Duel.SendtoGrave(dis,REASON_EFFECT)
		end
	end
end
