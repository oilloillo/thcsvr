 
--魔女之宴
function c10101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10101.target)
	e1:SetOperation(c10101.activate)
	c:RegisterEffect(e1)
end
function c10101.filter1(c)
	return c:IsSetCard(0x200) and c:IsFaceup()
end
function c10101.filter2(c)
	return c:IsSetCard(0x300) and c:IsFaceup()
end
function c10101.filter3(c)
	return c:IsSetCard(0x811) and c:IsFaceup()
end
function c10101.cfilter(c)
	return (c:GetAttack()>0 or c:GetDefence()>0) and c:IsFaceup()
end
function c10101.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=0
	if Duel.IsExistingMatchingCard(c10101.filter1,tp,LOCATION_MZONE,0,1,nil) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c10101.filter2,tp,LOCATION_MZONE,0,1,nil) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c10101.filter3,tp,LOCATION_MZONE,0,1,nil) then ct=ct+1 end
	local shc=Duel.IsExistingMatchingCard(c10101.cfilter,tp,0,LOCATION_MZONE,1,nil)
	local shh=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil)
	local shk=Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
	if chkc then return false end
	if chk==0 then return (ct>0 and shc) or (ct>1 and shh) or (ct>2 and shk) end
	if ct>2 then e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE+CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,3,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
	elseif ct>1 then e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
	end
end
function c10101.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	if Duel.IsExistingMatchingCard(c10101.filter1,tp,LOCATION_MZONE,0,1,nil) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c10101.filter2,tp,LOCATION_MZONE,0,1,nil) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c10101.filter3,tp,LOCATION_MZONE,0,1,nil) then ct=ct+1 end
	if ct>0 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(-1000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENCE)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
	if ct>1 then
		local dg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if dg:GetCount()>0 then
			local sg=dg:RandomSelect(1-tp,1)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			Duel.Damage(1-tp,1200,REASON_EFFECT)
		end
	end
	if ct>2 then
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local stg=tg:Filter(Card.IsRelateToEffect,nil,e)
		if stg:GetCount()>0 then
			Duel.SendtoHand(stg,nil,REASON_EFFECT)
			local gt=Duel.GetOperatedGroup()
			local gtc=gt:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_EXTRA)
			if gtc>0 then
				Duel.Draw(tp,gtc,REASON_EFFECT)
			end
			Duel.ConfirmCards(1-tp,stg)
		end
	end
end
