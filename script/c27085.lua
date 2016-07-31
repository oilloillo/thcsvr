--死欲的半灵✿魂魄妖梦
-- --require "expansions/nef/nef"
function c27085.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),5,2)
	--check overlay group when destroy
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EFFECT_DESTROY_REPLACE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(c27085.reptg)
	e0:SetValue(c27085.repval)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27085,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c27085.cost1)
	e1:SetTarget(c27085.target1)
	e1:SetOperation(c27085.operation)
	c:RegisterEffect(e1)
	--toohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27085,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c27085.cost2)
	e2:SetTarget(c27085.target2)
	e2:SetOperation(c27085.operation)
	c:RegisterEffect(e2)
	--to wife
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27085,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DESTROY)
	e3:SetLabelObject(e0)
	e3:SetTarget(c27085.thtg)
	e3:SetOperation(c27085.thop)
	c:RegisterEffect(e3)
end
function c27085.sfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_TOKEN)
end
function c27085.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c1=e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	local c2=Duel.CheckReleaseGroup(tp,c27085.sfilter,1,nil)
	if chk==0 then return c1 or c2 end
	local opt=2
	if c1 then opt=0 end
	if c2 then opt=1 end
	if c1 and c2 then opt=Duel.SelectOption(tp,aux.Stringid(27085,3),aux.Stringid(27085,4)) end
	if opt==0 then 
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		local sg=Duel.SelectReleaseGroup(tp,c27085.sfilter,1,1,nil)
		Duel.Release(sg,REASON_COST)
	end
end
function c27085.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27085.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c27085.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c1=e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST)
	local c2=Duel.CheckReleaseGroup(tp,c27085.sfilter,1,nil)
	if chk==0 then return c1 or c2 end
	local opt=2
	if c1 then opt=0 end
	if c2 then opt=1 end
	if c1 and c2 then opt=Duel.SelectOption(tp,aux.Stringid(27085,3),aux.Stringid(27085,4)) end
	if opt==0 then 
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
	else
		local sg=Duel.SelectReleaseGroup(tp,c27085.sfilter,1,1,nil)
		Duel.Release(sg,REASON_COST)
	end
end
function c27085.filter(c)
	return c:IsFaceup() and c:IsAbleToHand() and (c:GetLevel()>5 or c:GetRank()>5)
end
function c27085.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c27085.filter(chkc) end
	if chk==0 then return Duel.GetTurnPlayer()~=tp and Duel.IsExistingTarget(c27085.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c27085.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27085.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- local g = e:GetHandler():GetOverlayGroup()
	local e0 = e:GetLabelObject()
	local g = e0:GetLabelObject()
	if chk==0 then return g and g:GetCount()>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c27085.thop(e,tp,eg,ep,ev,re,r,rp)
	-- local g = e:GetHandler():GetOverlayGroup()
	local e0 = e:GetLabelObject()
	local g = e0:GetLabelObject()
--	Duel.Recover(0,g:GetCount(),0x40)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c27085.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local perg = e:GetLabelObject()
	if perg then 
		perg:DeleteGroup() 
	end
	local nowg = e:GetHandler():GetOverlayGroup()
	nowg:KeepAlive()
	e:SetLabelObject(nowg)
	-- Nef.Log(string.format("现在饼梦持有%d个素材", nowg:GetCount()))
	return false 
end
function c27085.repval(e,c)
	return false
end